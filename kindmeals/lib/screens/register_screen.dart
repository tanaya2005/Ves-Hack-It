import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindmeals/screens/api_service.dart';
import 'user_role.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;
  String? selectedRole;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController recipientIdController = TextEditingController();
  final TextEditingController volunteerDetailsController = TextEditingController();

  void _navigateBasedOnRole(String email) {
    switch (selectedRole) {
      case 'donor':
        Navigator.pushReplacementNamed(context, '/donor_profile', 
          arguments: {'email': email});
        break;
      case 'recipient':
        Navigator.pushReplacementNamed(context, '/recipient_profile',
          arguments: {'email': email});
        break;
      case 'volunteer':
        Navigator.pushReplacementNamed(context, '/volunteer_profile',
          arguments: {'email': email});
        break;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      addressController.text = '${position.latitude}, ${position.longitude}';
    });
  }

  Future<void> _registerWithEmail(BuildContext context) async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (Donor, Recipient, Volunteer)')),
      );
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        final userData = {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'location': addressController.text.trim(),
          'currentPassword': passwordController.text.trim(),
          if (selectedRole == 'donor')
            'organization': organizationController.text.trim(),
          if (selectedRole == 'recipient') ...{
            'recipientId': recipientIdController.text.trim(),
            'about': aboutController.text.trim(),
          },
          if (selectedRole == 'volunteer')
            'volunteerDetails': volunteerDetailsController.text.trim(),
        };

        try {
          final response = await ApiService.registerUser(userData, selectedRole!);
          print('MongoDB Registration successful: ${response['message']}');

          Navigator.pop(context); // Close loading

          if (!user.emailVerified) {
            await user.sendEmailVerification();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Registration Successful'),
                  content: const Text('A verification email has been sent. Please verify your email to continue.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateBasedOnRole(emailController.text.trim());
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } catch (mongoError) {
          Navigator.pop(context);
          await user.delete();
          throw Exception('Failed to save user data: $mongoError');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      print('Registration Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (Donor, Recipient, Volunteer)')),
      );
      return;
    }

    final GoogleSignIn googleSignIn = GoogleSignIn(signInOption: SignInOption.standard);
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      await googleSignIn.signOut();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        
        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final userData = {
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'phone': phoneController.text.trim(),
            'location': addressController.text.trim(),
            if (selectedRole == 'donor')
              'organization': organizationController.text.trim(),
            if (selectedRole == 'recipient') ...{
              'recipientId': recipientIdController.text.trim(),
              'about': aboutController.text.trim(),
            },
            if (selectedRole == 'volunteer')
              'volunteerDetails': volunteerDetailsController.text.trim(),
          };

          try {
            await ApiService.registerUser(userData, selectedRole!);
            Navigator.pop(context); // Close loading
            _navigateBasedOnRole(user.email!);
          } catch (mongoError) {
            throw Exception('Failed to save user data: $mongoError');
          }
        }
      }
    } catch (error) {
      Navigator.pop(context);
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In Failed')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Widget _buildRoleSpecificFields() {
    switch (selectedRole) {
      case 'donor':
        return _buildTextField(
          organizationController,
          'Organization Name',
          hint: 'Enter your organization name',
        );
      case 'recipient':
        return Column(
          children: [
            _buildTextField(
              recipientIdController,
              'Recipient ID',
              hint: 'Enter your recipient ID',
            ),
            _buildTextField(
              aboutController,
              'About',
              hint: 'Tell us about yourself',
              maxLines: 3,
            ),
          ],
        );
      case 'volunteer':
        return _buildTextField(
          volunteerDetailsController,
          'Volunteer Details',
          hint: 'Tell us about your volunteering experience',
          maxLines: 3,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenSize.height * 0.02),
              const Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Register to your account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: screenSize.height * 0.03),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              _buildTextField(nameController, 'Full Name'),
              _buildTextField(emailController, 'Email Address'),
              _buildTextField(passwordController, 'Password', isPassword: true),
              _buildTextField(confirmPasswordController, 'Confirm Password', isPassword: true),
              _buildTextField(phoneController, 'Phone Number', keyboardType: TextInputType.phone),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'Address (Tap to Get Current Location)',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: _getCurrentLocation,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'donor',
                        groupValue: selectedRole,
                        onChanged: (String? value) {
                          setState(() {
                            selectedRole = value;
                            userRole = value;
                          });
                        },
                      ),
                      const Text('Donor'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'recipient',
                        groupValue: selectedRole,
                        onChanged: (String? value) {
                          setState(() {
                            selectedRole = value;
                            userRole = value;
                          });
                        },
                      ),
                      const Text('Recipient'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: 'volunteer',
                        groupValue: selectedRole,
                        onChanged: (String? value) {
                          setState(() {
                            selectedRole = value;
                            userRole = value;
                          });
                        },
                      ),
                      const Text('Volunteer'),
                    ],
                  ),
                ],
              ),
              _buildRoleSpecificFields(),
              SizedBox(height: screenSize.height * 0.02),
              ElevatedButton(
                onPressed: () => _registerWithEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 15),
              SizedBox(height: screenSize.height * 0.02),
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  ElevatedButton.icon(
                  onPressed: () => _signInWithGoogle(context),
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text('Sign in with Google', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                  ),
                ],
                ),
              ),
              ),
            );
            }
          }
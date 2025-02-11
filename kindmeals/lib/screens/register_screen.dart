// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api, avoid_print

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  // New controllers for role-specific fields
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController recipientIdController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _image;
  String? selectedRole; // Variable to store the selected role ('donor', 'recipient')

  // To handle the current location fetching
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
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
        const SnackBar(
            content: Text('Location permission is permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      addressController.text = '${position.latitude}, ${position.longitude}';
    });
  }

  // Register using email and password
  Future<void> _registerWithEmail(BuildContext context) async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role (Donor, Recipient)')),
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
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Prepare user data for MongoDB with role-specific fields
        final userData = {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'location': addressController.text.trim(),
          'currentPassword': passwordController.text.trim(),
          // Include role-specific fields based on selection
          if (selectedRole == 'donor') 'organization': organizationController.text.trim(),
          if (selectedRole == 'recipient') ...{
            'recipientId': recipientIdController.text.trim(),
            'about': aboutController.text.trim(),
          },
        };

        try {
          final response = await ApiService.registerUser(userData, selectedRole!);
          print('MongoDB Registration successful: ${response['message']}');

          if (!user.emailVerified) {
            await user.sendEmailVerification();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification email sent. Please verify your email.')),
            );
          }
        } catch (mongoError) {
          await user.delete();
          throw Exception('Failed to save user data: $mongoError');
        }
      }
    } catch (e) {
      print('Registration Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
  // Check if email is verified
  Future<void> _checkEmailVerification() async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your email to continue.')),
      );
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle(BuildContext context) async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a role (Donor, Recipient, Volunteer)')),
      );
      return;
    }

    final GoogleSignIn googleSignIn =
        GoogleSignIn(signInOption: SignInOption.standard);
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In Failed')),
      );
    }
  }

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }
  Widget _buildRoleSpecificFields() {
    if (selectedRole == 'donor') {
      return _buildTextField(
        organizationController,
        'Organization Name',
        hint: 'Enter your organization name',
      );
    } else if (selectedRole == 'recipient') {
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
    }
    return const SizedBox.shrink();
  }

  
  // Build TextField widget
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
                  backgroundImage:
                      _image != null ? FileImage(File(_image!.path)) : null,
                  child: _image == null
                      ? const Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              _buildTextField(nameController, 'Full Name'),
              _buildTextField(emailController, 'Email Address'),
              _buildTextField(passwordController, 'Password', isPassword: true),
              _buildTextField(confirmPasswordController, 'Confirm Password',
                  isPassword: true),
              _buildTextField(phoneController, 'Phone Number',
                  keyboardType: TextInputType.phone),
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              // Using Wrap for responsive role selection
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
                ],
              ),
              _buildRoleSpecificFields(),
              SizedBox(height: screenSize.height * 0.02),
              ElevatedButton(
                onPressed: () => _registerWithEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _checkEmailVerification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify Email & Proceed',
                    style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              SizedBox(height: screenSize.height * 0.02),
              ElevatedButton(
                onPressed: () => _signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sign Up with Google',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

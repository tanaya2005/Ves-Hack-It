// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:kindmeals/screens/api_service.dart';
// import 'user_role.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   XFile? _image;
//   String? selectedRole;

//   // Controllers
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController organizationController = TextEditingController();
//   final TextEditingController aboutController = TextEditingController();
//   final TextEditingController recipientIdController = TextEditingController();
//   final TextEditingController volunteerDetailsController =
//       TextEditingController();

//   void _navigateBasedOnRole(String email) {
//     switch (selectedRole) {
//       case 'donor':
//         Navigator.pushReplacementNamed(context, '/donor_profile',
//             arguments: {'email': email});
//         break;
//       case 'recipient':
//         Navigator.pushReplacementNamed(context, '/recipient_profile',
//             arguments: {'email': email});
//         break;
//       case 'volunteer':
//         Navigator.pushReplacementNamed(context, '/volunteer_profile',
//             arguments: {'email': email});
//         break;
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('Location services are disabled. Please enable them.')),
//       );
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission denied.')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Location permission is permanently denied.')),
//       );
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       addressController.text = '${position.latitude}, ${position.longitude}';
//     });
//   }

//   Future<void> _registerWithEmail(BuildContext context) async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('Please select a role (Donor, Recipient, Volunteer)')),
//       );
//       return;
//     }

//     if (passwordController.text.trim() !=
//         confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match!')),
//       );
//       return;
//     }

//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       final UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         final userData = {
//           'name': nameController.text.trim(),
//           'email': emailController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'location': addressController.text.trim(),
//           'currentPassword': passwordController.text.trim(),
//           if (selectedRole == 'donor')
//             'organization': organizationController.text.trim(),
//           if (selectedRole == 'recipient') ...{
//             'recipientId': recipientIdController.text.trim(),
//             'about': aboutController.text.trim(),
//           },
//           if (selectedRole == 'volunteer')
//             'volunteerDetails': volunteerDetailsController.text.trim(),
//         };

//         try {
//           final response =
//               await ApiService.registerUser(userData, selectedRole!);
//           print('MongoDB Registration successful: ${response['message']}');

//           Navigator.pop(context); // Close loading

//           if (!user.emailVerified) {
//             await user.sendEmailVerification();
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Registration Successful'),
//                   content: const Text(
//                       'A verification email has been sent. Please verify your email to continue.'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _navigateBasedOnRole(emailController.text.trim());
//                       },
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         } catch (mongoError) {
//           Navigator.pop(context);
//           await user.delete();
//           throw Exception('Failed to save user data: $mongoError');
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         Navigator.pop(context);
//       }
//       print('Registration Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _signInWithGoogle(BuildContext context) async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('Please select a role (Donor, Recipient, Volunteer)')),
//       );
//       return;
//     }

//     final GoogleSignIn googleSignIn =
//         GoogleSignIn(signInOption: SignInOption.standard);
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(child: CircularProgressIndicator());
//         },
//       );

//       await googleSignIn.signOut();
//       final GoogleSignInAccount? account = await googleSignIn.signIn();
//       if (account != null) {
//         final GoogleSignInAuthentication googleAuth =
//             await account.authentication;
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         final userCredential = await _auth.signInWithCredential(credential);
//         final user = userCredential.user;

//         if (user != null) {
//           final userData = {
//             'name': user.displayName ?? '',
//             'email': user.email ?? '',
//             'phone': phoneController.text.trim(),
//             'location': addressController.text.trim(),
//             if (selectedRole == 'donor')
//               'organization': organizationController.text.trim(),
//             if (selectedRole == 'recipient') ...{
//               'recipientId': recipientIdController.text.trim(),
//               'about': aboutController.text.trim(),
//             },
//             if (selectedRole == 'volunteer')
//               'volunteerDetails': volunteerDetailsController.text.trim(),
//           };

//           try {
//             await ApiService.registerUser(userData, selectedRole!);
//             Navigator.pop(context); // Close loading
//             _navigateBasedOnRole(user.email!);
//           } catch (mongoError) {
//             throw Exception('Failed to save user data: $mongoError');
//           }
//         }
//       }
//     } catch (error) {
//       Navigator.pop(context);
//       print('Google Sign-In Error: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Google Sign-In Failed')),
//       );
//     }
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedImage =
//         await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedImage;
//     });
//   }

//   Widget _buildRoleSpecificFields() {
//     switch (selectedRole) {
//       case 'donor':
//         return _buildTextField(
//           organizationController,
//           'Organization Name',
//           hint: 'Enter your organization name',
//         );
//       case 'recipient':
//         return Column(
//           children: [
//             _buildTextField(
//               recipientIdController,
//               'Recipient ID',
//               hint: 'Enter your recipient ID',
//             ),
//             _buildTextField(
//               aboutController,
//               'About',
//               hint: 'Tell us about yourself',
//               maxLines: 3,
//             ),
//           ],
//         );
//       case 'volunteer':
//         return _buildTextField(
//           volunteerDetailsController,
//           'Volunteer Details',
//           hint: 'Tell us about your volunteering experience',
//           maxLines: 3,
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     bool isPassword = false,
//     TextInputType keyboardType = TextInputType.text,
//     String? hint,
//     int? maxLines,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         keyboardType: keyboardType,
//         maxLines: maxLines ?? 1,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//           filled: true,
//           fillColor: Colors.grey[200],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: screenSize.height * 0.02),
//               const Text(
//                 'Create Account',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Register to your account',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//               ),
//               SizedBox(height: screenSize.height * 0.03),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 55,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage:
//                       _image != null ? FileImage(File(_image!.path)) : null,
//                   child: _image == null
//                       ? const Icon(Icons.camera_alt,
//                           size: 50, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//               SizedBox(height: screenSize.height * 0.03),
//               _buildTextField(nameController, 'Full Name'),
//               _buildTextField(emailController, 'Email Address'),
//               _buildTextField(passwordController, 'Password', isPassword: true),
//               _buildTextField(confirmPasswordController, 'Confirm Password',
//                   isPassword: true),
//               _buildTextField(phoneController, 'Phone Number',
//                   keyboardType: TextInputType.phone),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: TextField(
//                   controller: addressController,
//                   decoration: InputDecoration(
//                     hintText: 'Address (Tap to Get Current Location)',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.location_on),
//                       onPressed: _getCurrentLocation,
//                     ),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 12),
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenSize.height * 0.02),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 spacing: 20,
//                 runSpacing: 10,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Radio<String>(
//                         value: 'donor',
//                         groupValue: selectedRole,
//                         onChanged: (String? value) {
//                           setState(() {
//                             selectedRole = value;
//                             userRole = value;
//                           });
//                         },
//                       ),
//                       const Text('Donor'),
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Radio<String>(
//                         value: 'recipient',
//                         groupValue: selectedRole,
//                         onChanged: (String? value) {
//                           setState(() {
//                             selectedRole = value;
//                             userRole = value;
//                           });
//                         },
//                       ),
//                       const Text('Recipient'),
//                     ],
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Radio<String>(
//                         value: 'volunteer',
//                         groupValue: selectedRole,
//                         onChanged: (String? value) {
//                           setState(() {
//                             selectedRole = value;
//                             userRole = value;
//                           });
//                         },
//                       ),
//                       const Text('Volunteer'),
//                     ],
//                   ),
//                 ],
//               ),
//               _buildRoleSpecificFields(),
//               SizedBox(height: screenSize.height * 0.02),
//               ElevatedButton(
//                 onPressed: () => _registerWithEmail(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text('Register', style: TextStyle(fontSize: 16)),
//               ),
//               const SizedBox(height: 15),
//               SizedBox(height: screenSize.height * 0.02),
//               Row(
//                 children: const [
//                   Expanded(child: Divider(thickness: 1)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Text('OR'),
//                   ),
//                   Expanded(child: Divider(thickness: 1)),
//                 ],
//               ),
//               SizedBox(height: screenSize.height * 0.02),
//               ElevatedButton.icon(
//                 onPressed: () => _signInWithGoogle(context),
//                 icon: const Icon(Icons.login, color: Colors.white),
//                 label: const Text('Sign in with Google',
//                     style: TextStyle(fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               SizedBox(height: screenSize.height * 0.02),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Already have an account?'),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     child: const Text('Login',
//                         style: TextStyle(color: Colors.green)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  XFile? _profileImage;
  XFile? _docImage;
  String? selectedRole;
  bool isLoading = false;
  final Dio dio = Dio();
  final String baseUrl = 'http://192.168.124.180:3000'; // For Android emulator

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController identificationDocController =
      TextEditingController();

  // Location variables
  double? latitude;
  double? longitude;

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
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission is permanently denied.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationController.text = '${position.latitude}, ${position.longitude}';
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _registerWithEmail() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a role (Donor, Recipient, Volunteer)')),
      );
      return;
    }

    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image')),
      );
      return;
    }

    if (selectedRole == 'volunteer' && _docImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload your identification document')),
      );
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (selectedRole == 'donor' || selectedRole == 'recipient') {
      if (orgNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization name is required')),
        );
        return;
      }
    }

    if (selectedRole == 'volunteer' &&
        identificationDocController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Identification document details are required')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Create a FormData object for the API request
      FormData formData = FormData();

      // Common fields for all user types
      formData.fields.addAll([
        MapEntry('username', usernameController.text.trim()),
        MapEntry('email', emailController.text.trim()),
        MapEntry('contact', phoneController.text.trim()),
        MapEntry('currentPassword', passwordController.text.trim()),
        MapEntry('about', aboutController.text.trim()),
      ]);

      // Add location data if available
      if (latitude != null && longitude != null) {
        formData.fields.addAll([
          MapEntry('latitude', latitude.toString()),
          MapEntry('longitude', longitude.toString()),
        ]);
      }

      // Add profile image
      if (_profileImage != null) {
        String fileName = path.basename(_profileImage!.path);
        formData.files.add(MapEntry(
          'profileImage',
          await MultipartFile.fromFile(
            _profileImage!.path,
            filename: fileName,
            contentType: MediaType('image', fileName.split('.').last),
          ),
        ));
      }

      // Role-specific fields
      switch (selectedRole) {
        case 'donor':
        case 'recipient':
          formData.fields
              .add(MapEntry('orgName', orgNameController.text.trim()));
          break;
        case 'volunteer':
          formData.fields.add(MapEntry(
              'identificationDoc', identificationDocController.text.trim()));

          // Add document image for volunteer
          if (_docImage != null) {
            String docFileName = path.basename(_docImage!.path);
            formData.files.add(MapEntry(
              'docImage',
              await MultipartFile.fromFile(
                _docImage!.path,
                filename: docFileName,
                contentType: MediaType('image', docFileName.split('.').last),
              ),
            ));
          }
          break;
      }

      // Determine endpoint based on user role
      String endpoint;
      switch (selectedRole) {
        case 'donor':
          endpoint = '/api/donors/register';
          break;
        case 'recipient':
          endpoint = '/api/recipients/register';
          break;
        case 'volunteer':
          endpoint = '/api/volunteers/register';
          break;
        default:
          throw Exception('Invalid role selected');
      }

      // Send registration request
      final response = await dio.post(
        '$baseUrl$endpoint',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${selectedRole?.capitalize()} registered successfully!')),
        );

        // Also register with Firebase Authentication
        try {
          final UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          if (userCredential.user != null &&
              !userCredential.user!.emailVerified) {
            await userCredential.user!.sendEmailVerification();
          }
        } catch (firebaseError) {
          print('Firebase registration error: $firebaseError');
          // Continue with app flow even if Firebase registration fails
        }

        _navigateBasedOnRole(emailController.text.trim());
      } else {
        throw Exception('Registration failed');
      }
    } catch (error) {
      print('Registration error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a role (Donor, Recipient, Volunteer)')),
      );
      return;
    }

    // Check required fields before even starting Google sign-in
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    if (selectedRole == 'donor' || selectedRole == 'recipient') {
      if (orgNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization name is required')),
        );
        return;
      }
    }

    if (selectedRole == 'volunteer' &&
        identificationDocController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Identification document details are required')),
      );
      return;
    }

    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image')),
      );
      return;
    }

    if (selectedRole == 'volunteer' && _docImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload your identification document')),
      );
      return;
    }

    final GoogleSignIn googleSignIn =
        GoogleSignIn(signInOption: SignInOption.standard);

    setState(() {
      isLoading = true;
    });

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

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          // Pre-fill name and email from Google account
          setState(() {
            usernameController.text = user.displayName ?? '';
            emailController.text = user.email ?? '';
          });

          // Add debug logging
          print('Creating FormData for Google registration');
          print('Username: ${user.displayName}');
          print('Email: ${user.email}');
          print('Phone: ${phoneController.text.trim()}');
          print('Role: $selectedRole');

          // Continue with backend registration
          FormData formData = FormData();

          // Common fields
          formData.fields.addAll([
            MapEntry('username', user.displayName ?? ''),
            MapEntry('email', user.email ?? ''),
            MapEntry('contact', phoneController.text.trim()),
            // Use a simpler password format that's more likely to pass validation
            MapEntry('currentPassword', 'GoogleAuth123!'),
            MapEntry('about', aboutController.text.trim()),
          ]);

          // Add location data if available
          if (latitude != null && longitude != null) {
            formData.fields.addAll([
              MapEntry('latitude', latitude.toString()),
              MapEntry('longitude', longitude.toString()),
            ]);
          }

          // Add profile image
          if (_profileImage != null) {
            String fileName = path.basename(_profileImage!.path);
            formData.files.add(MapEntry(
              'profileImage',
              await MultipartFile.fromFile(
                _profileImage!.path,
                filename: fileName,
                contentType: MediaType('image', fileName.split('.').last),
              ),
            ));
          }

          // Role-specific fields
          switch (selectedRole) {
            case 'donor':
            case 'recipient':
              formData.fields
                  .add(MapEntry('orgName', orgNameController.text.trim()));
              break;
            case 'volunteer':
              formData.fields.add(MapEntry('identificationDoc',
                  identificationDocController.text.trim()));

              // Add document image for volunteer
              if (_docImage != null) {
                String docFileName = path.basename(_docImage!.path);
                formData.files.add(MapEntry(
                  'docImage',
                  await MultipartFile.fromFile(
                    _docImage!.path,
                    filename: docFileName,
                    contentType:
                        MediaType('image', docFileName.split('.').last),
                  ),
                ));
              }
              break;
          }

          // Determine endpoint based on user role
          String endpoint;
          switch (selectedRole) {
            case 'donor':
              endpoint = '/api/donors/register';
              break;
            case 'recipient':
              endpoint = '/api/recipients/register';
              break;
            case 'volunteer':
              endpoint = '/api/volunteers/register';
              break;
            default:
              throw Exception('Invalid role selected');
          }

          // Add debug logging for request
          print('Sending request to: $baseUrl$endpoint');

          try {
            // Add response logging
            final response = await dio.post(
              '$baseUrl$endpoint',
              data: formData,
              options: Options(
                contentType: 'multipart/form-data',
                followRedirects: false,
                validateStatus: (status) {
                  // Log ALL responses, even errors
                  print('Response status: $status');
                  return status! < 500; // Only throw on server errors
                },
              ),
            );

            print('Response data: ${response.data}');

            if (response.statusCode == 201 || response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '${selectedRole?.capitalize()} registered successfully with Google!')),
              );
              _navigateBasedOnRole(user.email!);
            } else {
              // Handle other status codes
              throw Exception(
                  'Registration failed with status: ${response.statusCode}, message: ${response.data}');
            }
          } catch (dioError) {
            print('API request error: $dioError');
            if (dioError is DioException) {
              print('Response data: ${dioError.response?.data}');
            }
            throw dioError; // Re-throw to be caught by outer catch
          }
        }
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed: ${error.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  Future<void> _pickDocImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedImage != null) {
      setState(() {
        _docImage = pickedImage;
      });
    }
  }

  Widget _buildRoleSpecificFields() {
    switch (selectedRole) {
      case 'donor':
      case 'recipient':
        return _buildTextField(
          orgNameController,
          'Organization Name',
          hint: 'Enter your organization name',
          icon: Icons.business,
        );
      case 'volunteer':
        return Column(
          children: [
            _buildTextField(
              identificationDocController,
              'Identification Document',
              hint: 'Enter your ID details',
              icon: Icons.badge,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDocImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: _docImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_docImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.upload_file, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Upload ID Document'),
                        ],
                      ),
              ),
            ),
          ],
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
    IconData? icon,
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
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenSize.height * 0.01),
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Join KindMeals and help fight food waste',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImage != null
                                ? FileImage(File(_profileImage!.path))
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.camera_alt,
                                    size: 50, color: Colors.grey)
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),

                  // Role Selection
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'I am a:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildRoleButton(
                                'donor', 'Donor', Icons.volunteer_activism),
                            _buildRoleButton(
                                'recipient', 'Recipient', Icons.business),
                            _buildRoleButton('volunteer', 'Volunteer',
                                Icons.directions_bike),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenSize.height * 0.02),

                  // Basic Info Fields
                  _buildTextField(
                    usernameController,
                    'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person,
                  ),
                  _buildTextField(
                    emailController,
                    'Email Address',
                    hint: 'Enter your email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    passwordController,
                    'Password',
                    isPassword: true,
                    hint: 'Create password',
                    icon: Icons.lock,
                  ),
                  _buildTextField(
                    confirmPasswordController,
                    'Confirm Password',
                    isPassword: true,
                    hint: 'Confirm your password',
                    icon: Icons.lock_outline,
                  ),
                  _buildTextField(
                    phoneController,
                    'Phone Number',
                    hint: 'Enter your phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),

                  // Location Field
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        hintText: 'Tap to get current location',
                        prefixIcon: const Icon(Icons.location_on),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.my_location),
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

                  _buildTextField(
                    aboutController,
                    'About',
                    hint: 'Tell us a bit about yourself',
                    icon: Icons.info_outline,
                    maxLines: 3,
                  ),

                  // Role-specific fields
                  _buildRoleSpecificFields(),

                  SizedBox(height: screenSize.height * 0.02),

                  // Register Button
                  ElevatedButton(
                    onPressed: _registerWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),

                  // Google Sign-in
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text('Sign in with Google',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
                        child: const Text('Login',
                            style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Loading Overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String value, String label, IconData icon) {
    final bool isSelected = selectedRole == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

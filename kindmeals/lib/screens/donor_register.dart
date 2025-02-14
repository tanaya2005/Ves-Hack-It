// // donor_register.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';

// class DonorRegisterScreen extends StatefulWidget {
//   const DonorRegisterScreen({super.key});

//   @override
//   _DonorRegisterScreenState createState() => _DonorRegisterScreenState();
// }

// class _DonorRegisterScreenState extends State<DonorRegisterScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   XFile? _image;

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled. Please enable them.')),
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
//         const SnackBar(content: Text('Location permission is permanently denied.')),
//       );
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       addressController.text = '${position.latitude}, ${position.longitude}';
//     });
//   }

//   Future<void> _registerWithEmail() async {
//     if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match!')),
//       );
//       return;
//     }

//     try {
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Verification email sent. Please verify your email.')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Signed in with Google successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
//       );
//     }
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedImage;
//     });
//   }

//   Widget _buildTextField(TextEditingController controller, String hint,
//       {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//           filled: true,
//           fillColor: Colors.grey[200],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register as Donor'),
//       ),
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
//                     child: _image == null
//                         ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTextField(nameController, 'Full Name'),
//                 _buildTextField(emailController, 'Email Address'),
//                 _buildTextField(passwordController, 'Password', isPassword: true),
//                 _buildTextField(confirmPasswordController, 'Confirm Password', isPassword: true),
//                 _buildTextField(phoneController, 'Phone Number', keyboardType: TextInputType.phone),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: TextField(
//                     controller: addressController,
//                     decoration: InputDecoration(
//                       hintText: 'Address (Tap to Get Current Location)',
//                       suffixIcon: IconButton(
//                         icon: const Icon(Icons.location_on),
//                         onPressed: _getCurrentLocation,
//                       ),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _registerWithEmail,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: const Text('Register', style: TextStyle(fontSize: 16)),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: _signInWithGoogle,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   icon: const Icon(Icons.login),
//                   label: const Text('Sign in with Google', style: TextStyle(fontSize: 16)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
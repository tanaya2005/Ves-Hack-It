// lib/screens/volunteer_signup.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:kindmeals/models/volunteer.dart';
import '../services/api_service.dart';

class VolunteerSignup extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  VolunteerSignup({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();

  // Save volunteer data to MongoDB
  Future<void> _saveVolunteerData(BuildContext context, String uid) async {
    try {
      final volunteer = {
        'id': uid,
        'name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'availableDays': [] // Add this even if empty
      };

      print('Volunteer data: $volunteer'); // Debug print

      await _apiService.registerVolunteer(volunteer);

      // Navigate only after successful save
      Navigator.pushReplacementNamed(context, '/volunteer_document_dashboard');
    } catch (e) {
      print('Error saving volunteer data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving volunteer data: ${e.toString()}')),
      );
    }
  }

  // Email/Password Sign-Up
  Future<void> _signUpWithEmail(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save volunteer data after successful authentication
      if (userCredential.user != null) {
        await _saveVolunteerData(context, userCredential.user!.uid);
      }
    } catch (e) {
      print('Email Sign-Up Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Google Sign-Up
  Future<void> _signUpWithGoogle(BuildContext context) async {
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
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Pre-fill email field with Google account email
        emailController.text = account.email;

        // If user exists, save volunteer data
        if (userCredential.user != null) {
          await _saveVolunteerData(context, userCredential.user!.uid);
        }
      }
    } catch (error) {
      print('Google Sign-Up Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-Up Failed')),
      );
    }
  }

  // Form validation
  bool _validateForm() {
    return fullNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        (passwordController.text.isNotEmpty ||
            _auth.currentUser?.providerData
                    .any((element) => element.providerId == 'google.com') ==
                true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Join as a Volunteer!',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Sign up to make a difference',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
                SizedBox(height: 30),

                // Full Name
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                      hintText: 'Full Name', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),

                // Phone Number
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: 'Phone Number', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),

                // Address
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                      hintText: 'Address', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: 'Email', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password', border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      _signUpWithEmail(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50)),
                  child: Text('Sign Up'),
                ),
                SizedBox(height: 20),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          Text('OR', style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                SizedBox(height: 20),

                // Google Sign Up Button
                ElevatedButton(
                  onPressed: () => _signUpWithGoogle(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/google_logo.png', height: 24),
                      SizedBox(width: 10),
                      Text('Sign Up with Google'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                        style: TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/volunteerLogin'),
                      child:
                          const Text('Login', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

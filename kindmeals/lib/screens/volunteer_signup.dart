// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class VolunteerSignup extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  VolunteerSignup({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email/Password Sign-Up
  Future<void> _signUpWithEmail(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(
          context, '/volunteer_document_dashboard'); // Redirect after signup
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
      await googleSignIn.signOut(); // Force account chooser every time
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(
            context, '/volunteer_document_dashboard'); // Redirect after signup
      }
    } catch (error) {
      print('Google Sign-Up Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-Up Failed')),
      );
    }
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
                  onPressed: () => _signUpWithEmail(context),
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

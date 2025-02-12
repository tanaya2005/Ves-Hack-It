import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VolunteerSignup extends StatefulWidget {
  const VolunteerSignup({super.key});

  @override
  _VolunteerSignupState createState() => _VolunteerSignupState();
}

class _VolunteerSignupState extends State<VolunteerSignup> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  final String apiUrl =
      "http://192.168.29.121:5000/signup"; // Change for real device

  Future<void> _signUp() async {
    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullNameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/volunteer_document_dashboard');
    } else {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${data['message']}")),
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
                const Text('Join as a Volunteer!',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Sign up to make a difference',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
                const SizedBox(height: 30),

                // Full Name
                TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                        hintText: 'Full Name', border: OutlineInputBorder())),
                const SizedBox(height: 20),

                // Phone Number
                TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder())),
                const SizedBox(height: 20),

                // Address
                TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                        hintText: 'Address', border: OutlineInputBorder())),
                const SizedBox(height: 20),

                // Email
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'Email', border: OutlineInputBorder())),
                const SizedBox(height: 20),

                // Password
                TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Password', border: OutlineInputBorder())),
                const SizedBox(height: 20),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50)),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                        style: TextStyle(fontSize: 14)),
                    TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/volunteerLogin'),
                        child: const Text('Login',
                            style: TextStyle(fontSize: 14))),
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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement authentication logic
      Navigator.pushNamed(context, '/donorDashboard'); // Change based on user role
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Email', controller: emailController, keyboardType: TextInputType.emailAddress),
              CustomTextField(label: 'Password', controller: passwordController, obscureText: true),
              SizedBox(height: 20),
              CustomButton(text: 'Login', onPressed: _login),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgotPassword');
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

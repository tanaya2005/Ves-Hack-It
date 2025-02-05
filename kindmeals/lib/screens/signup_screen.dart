// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement authentication logic
      Navigator.pushNamed(context, '/roleSelection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Full Name', controller: nameController),
              CustomTextField(label: 'Email', controller: emailController, keyboardType: TextInputType.emailAddress),
              CustomTextField(label: 'Password', controller: passwordController, obscureText: true),
              SizedBox(height: 20),
              CustomButton(text: 'Register', onPressed: _signup),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _selectedRole = 'Donor'; // Default role

  void _signup() {
    if (_formKey.currentState!.validate()) {
      // ✅ Navigate to OTP screen with selected role
      Navigator.pushNamed(
        context,
        '/otpVerification',
        arguments: {'role': _selectedRole}, // Passing role to OTP screen
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Full Name', controller: nameController),
              CustomTextField(label: 'Email', controller: emailController),
              CustomTextField(label: 'Password', controller: passwordController, obscureText: true),
              SizedBox(height: 10),
              Text('Register as:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListTile(
                title: Text('Donor'),
                leading: Radio(
                  value: 'Donor',
                  groupValue: _selectedRole,
                  onChanged: (value) => setState(() => _selectedRole = value.toString()),
                ),
              ),
              ListTile(
                title: Text('Recipient'),
                leading: Radio(
                  value: 'Recipient',
                  groupValue: _selectedRole,
                  onChanged: (value) => setState(() => _selectedRole = value.toString()),
                ),
              ),
              ListTile(
                title: Text('Volunteer'),
                leading: Radio(
                  value: 'Volunteer',
                  groupValue: _selectedRole,
                  onChanged: (value) => setState(() => _selectedRole = value.toString()),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(text: 'Register', onPressed: _signup),
            ],
          ),
        ),
      ),
    );
  }
}

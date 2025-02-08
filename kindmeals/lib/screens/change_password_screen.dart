import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, required String currentPassword});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool forgotPassword = false;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailOrPhoneController = TextEditingController();

  void changePassword() {
    if (newPasswordController.text == confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
    }
  }

  void sendVerificationLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification link sent to ${emailOrPhoneController.text}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!forgotPassword) ...[
              buildTextField('Old Password', oldPasswordController, obscureText: true),
              buildTextField('New Password', newPasswordController, obscureText: true),
              buildTextField('Confirm New Password', confirmPasswordController, obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: changePassword,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Change Password'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    forgotPassword = true;
                  });
                },
                child: const Text('Forgot Password?'),
              ),
            ] else ...[
              buildTextField('Email or Phone Number', emailOrPhoneController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendVerificationLink,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Send Verification Link'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    forgotPassword = false;
                  });
                },
                child: const Text('Back to Change Password'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

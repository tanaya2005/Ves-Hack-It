import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OTPVerificationScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  OTPVerificationScreen({super.key});

  void _verifyOTP(BuildContext context) {
    if (otpController.text == '1234') {
      final role = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {'role': 'Donor'};

      if (role['role'] == 'Donor') {
        Navigator.pushReplacementNamed(context, '/donorDashboard');
      } else if (role['role'] == 'Recipient') {
        Navigator.pushReplacementNamed(context, '/recipientDashboard');
      } else if (role['role'] == 'Volunteer') {
        Navigator.pushReplacementNamed(context, '/volunteerDashboard');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to your registered email/phone', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(text: 'Verify OTP', onPressed: () => _verifyOTP(context)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Privacy Policy"), backgroundColor: Colors.green),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Here is the privacy policy...",
            style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

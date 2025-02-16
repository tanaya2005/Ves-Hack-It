import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Terms and Conditions"),
          backgroundColor: Colors.green),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Here are the terms and conditions...",
            style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

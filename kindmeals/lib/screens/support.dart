import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Support"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("For support, contact us at: support@example.com",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            const Text("Phone: +91 9876543210", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

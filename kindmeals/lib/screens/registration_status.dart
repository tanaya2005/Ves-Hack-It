import 'package:flutter/material.dart';

class RegistrationStatus extends StatelessWidget {
  const RegistrationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Registration Complete")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Your application is under verification. Account will get activated in 48 hours.",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            _buildStatusTile(
                "Personal Documents", "Verification Pending", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(String title, String status, Color color) {
    return ListTile(
      title: Text(title),
      trailing: Text(status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

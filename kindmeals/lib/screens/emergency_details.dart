import 'package:flutter/material.dart';

class EmergencyDetailsPage extends StatefulWidget {
  final Function(bool) onComplete; // Callback function

  const EmergencyDetailsPage({super.key, required this.onComplete});

  @override
  EmergencyDetailsPageState createState() => EmergencyDetailsPageState();
}

class EmergencyDetailsPageState extends State<EmergencyDetailsPage> {
  final TextEditingController emergencyContact1Controller =
      TextEditingController();
  final TextEditingController emergencyContact2Controller =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isCompleted = false;
  String? errorMessage;

  void submitEmergencyDetails() {
    setState(() {
      errorMessage = null;
    });

    if (emergencyContact1Controller.text.isEmpty ||
        emergencyContact2Controller.text.isEmpty ||
        addressController.text.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields before submitting.";
      });
      return;
    }

    // Mark as completed and go back to the dashboard
    widget.onComplete(true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This information is confidential and will be safe with us.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emergencyContact1Controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emergencyContact2Controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Home Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitEmergencyDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

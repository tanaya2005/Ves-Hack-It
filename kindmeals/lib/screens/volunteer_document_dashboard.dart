import 'package:flutter/material.dart';
// import 'personal_documents_upload.dart';
// import 'aadhar_upload.dart';

class VolunteerDocumentDashboard extends StatelessWidget {
  const VolunteerDocumentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Welcome to Food Donation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  Text(
                    "Just a few steps to complete and then you can start volunteering!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Pending Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDocumentTile(
                context, "Personal Documents", "/personalDocuments"),
            _buildDocumentTile(context, "Vehicle Details", "/vehicleDetails"),
            _buildDocumentTile(
                context, "Bank Account Details", "/bankAccountDetails"),
            _buildDocumentTile(
                context, "Emergency Details", "/emergencyDetails"),
            const SizedBox(height: 20),
            const Text("Completed Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDocumentTile(context, "Personal Information", null,
                isCompleted: true),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text("Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile(BuildContext context, String title, String? route,
      {bool isCompleted = false}) {
    return ListTile(
      title: Text(title),
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.arrow_forward_ios),
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kindmeals/screens/bank_account_details.dart';
import 'package:kindmeals/screens/emergency_details.dart';
import 'package:kindmeals/screens/vehicle_details.dart';
import 'package:kindmeals/screens/personal_documents_upload.dart';

class VolunteerDocumentDashboard extends StatefulWidget {
  const VolunteerDocumentDashboard({super.key});

  @override
  VolunteerDocumentDashboardState createState() =>
      VolunteerDocumentDashboardState();
}

class VolunteerDocumentDashboardState
    extends State<VolunteerDocumentDashboard> {
  // Track which documents are completed
  Map<String, bool> completedDocuments = {
    "Personal Documents": false,
    "Vehicle Details": false,
    "Bank Account Details": false,
    "Emergency Details": false,
  };

  /// ✅ Updates the status of a completed document
  void updateCompletionStatus(String document, bool status) {
    setState(() {
      completedDocuments[document] = status;
    });

    // ✅ Check if all documents are completed
    if (completedDocuments.values.every((status) => status == true)) {
      moveToCompletedDocuments();
    }
  }

  /// ✅ Moves "Personal Documents" to completed section
  void moveToCompletedDocuments() {
    setState(() {
      print("✅ Personal Documents are completed!");
      completedDocuments["Personal Documents"] = true;
    });
  }

  /// ✅ Checks if all documents are completed before submission
  void checkCompletion() {
    if (completedDocuments.values.every((status) => status == true)) {
      // Navigate to Profile Screen when all are completed
      Navigator.pushReplacementNamed(context, "/volunteerprofileScreen");
    } else {
      // Show error if not all documents are completed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please complete all required documents before proceeding."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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

            // Pending Documents
            const Text("Pending Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (var entry in completedDocuments.entries)
              if (!entry.value) _buildDocumentTile(context, entry.key),

            const SizedBox(height: 20),

            // Completed Documents
            const Text("Completed Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            for (var entry in completedDocuments.entries)
              if (entry.value)
                _buildDocumentTile(context, entry.key, isCompleted: true),

            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: checkCompletion,
              child: const Text("Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile(BuildContext context, String title,
      {bool isCompleted = false}) {
    return ListTile(
      title: Text(title),
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.arrow_forward_ios),
      onTap: !isCompleted
          ? () {
              if (title == "Personal Documents") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalDocumentsUpload(
                      onComplete: (bool completed) =>
                          updateCompletionStatus(title, completed),
                    ),
                  ),
                );
              }
              if (title == "Vehicle Details") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailsPage(
                      onComplete: (bool completed) =>
                          updateCompletionStatus(title, completed),
                    ),
                  ),
                );
              }
              if (title == "Bank Account Details") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BankAccountDetailsPage(
                      onComplete: (bool completed) =>
                          updateCompletionStatus(title, completed),
                    ),
                  ),
                );
              }
              if (title == "Emergency Details") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyDetailsPage(
                      onComplete: (bool completed) =>
                          updateCompletionStatus(title, completed),
                    ),
                  ),
                );
              }
            }
          : null,
    );
  }
}

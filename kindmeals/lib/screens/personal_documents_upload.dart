import 'package:flutter/material.dart';
import 'aadhar_upload.dart';
import 'driving_license_upload.dart';
import 'pan_card_upload.dart';

class PersonalDocumentsUpload extends StatefulWidget {
  final Function(bool) onComplete; // ✅ Added onComplete callback

  const PersonalDocumentsUpload({super.key, required this.onComplete});

  @override
  State<PersonalDocumentsUpload> createState() =>
      PersonalDocumentsUploadState();
}

class PersonalDocumentsUploadState extends State<PersonalDocumentsUpload> {
  bool isAadharCompleted = false;
  bool isPanCompleted = false;
  bool isDrivingLicenseCompleted = false;

  /// ✅ Check if all personal documents are completed and notify dashboard
  void checkCompletion() {
    if (isAadharCompleted && isPanCompleted && isDrivingLicenseCompleted) {
      widget.onComplete(
          true); // ✅ Notify dashboard that Personal Docs are completed
    }
  }

  /// ✅ Navigate to Document Upload Pages and Update Completion Status
  void navigateToDocumentPage(Widget page, String docType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (result == true) {
      // ✅ Check if the page returned completion
      setState(() {
        if (docType == "Aadhar") isAadharCompleted = true;
        if (docType == "PAN") isPanCompleted = true;
        if (docType == "Driving License") isDrivingLicenseCompleted = true;
      });
      checkCompletion(); // ✅ Check if all documents are completed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Documents"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload clear photos of the following documents for verification:",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            /// ✅ Aadhar Card Upload
            ListTile(
              title: const Text("Aadhar Card"),
              trailing: Icon(
                isAadharCompleted
                    ? Icons.check_circle
                    : Icons.arrow_forward_ios,
                color: isAadharCompleted ? Colors.green : null,
              ),
              onTap: () => navigateToDocumentPage(
                  AadharUploadPage(onComplete: (bool completed) {
                setState(() {
                  isAadharCompleted = completed;
                });
                checkCompletion();
              }), "Aadhar"),
            ),

            /// ✅ PAN Card Upload
            ListTile(
              title: const Text("PAN Card"),
              trailing: Icon(
                isPanCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
                color: isPanCompleted ? Colors.green : null,
              ),
              onTap: () => navigateToDocumentPage(
                  PanCardDetailsPage(onComplete: (bool completed) {
                setState(() {
                  isPanCompleted = completed;
                });
                checkCompletion();
              }), "PAN"),
            ),

            /// ✅ Driving License Upload
            ListTile(
              title: const Text("Driving License"),
              trailing: Icon(
                isDrivingLicenseCompleted
                    ? Icons.check_circle
                    : Icons.arrow_forward_ios,
                color: isDrivingLicenseCompleted ? Colors.green : null,
              ),
              onTap: () => navigateToDocumentPage(
                  DrivingLicensePage(onComplete: (bool completed) {
                setState(() {
                  isDrivingLicenseCompleted = completed;
                });
                checkCompletion();
              }), "Driving License"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:kindmeals/screens/volunteer_document_dashboard.dart';

class DrivingLicensePage extends StatefulWidget {
  final Function(bool) onComplete; // Accept onComplete callback

  const DrivingLicensePage({super.key, required this.onComplete});

  @override
  _DrivingLicensePageState createState() => _DrivingLicensePageState();
}

class _DrivingLicensePageState extends State<DrivingLicensePage> {
  final TextEditingController licenseNumberController = TextEditingController();
  File? _licenseImage;
  final picker = ImagePicker();
  String? errorMessage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);
      });
    }
  }

  void _submitDrivingLicense() {
    if (licenseNumberController.text.isEmpty || _licenseImage == null) {
      setState(() {
        errorMessage = "All fields are required.";
      });
      return;
    }

    // ✅ Mark Personal Documents as completed
    widget.onComplete(true);

    Navigator.pop(
        context, true); // ✅ Return true when Driving License is completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Driving License Details"),
          backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter Driving License Number"),
            TextField(
              controller: licenseNumberController,
              maxLength: 16,
              decoration: InputDecoration(
                labelText: "Driving License Number",
                border: const OutlineInputBorder(),
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Upload a picture of your Driving License"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: _licenseImage == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey),
                    )
                  : Image.file(_licenseImage!,
                      height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDrivingLicense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

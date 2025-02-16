import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'pan_card_details.dart';

class AadharUploadPage extends StatefulWidget {
  final Function(bool) onComplete; // Accept onComplete callback

  const AadharUploadPage({super.key, required this.onComplete});

  @override
  _AadharUploadPageState createState() => _AadharUploadPageState();
}

class _AadharUploadPageState extends State<AadharUploadPage> {
  File? frontAadhar;
  File? backAadhar;
  final TextEditingController aadharNumberController = TextEditingController();
  String? errorMessage;

  Future<void> _pickImage(bool isFront) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          frontAadhar = File(pickedFile.path);
        } else {
          backAadhar = File(pickedFile.path);
        }
      });
    }
  }

  void _submitAadhar() {
    String aadharNumber = aadharNumberController.text;

    if (aadharNumber.isEmpty || aadharNumber.length != 12) {
      setState(() {
        errorMessage = "Aadhar number must be exactly 12 digits.";
      });
      return;
    }

    if (frontAadhar == null || backAadhar == null) {
      setState(() {
        errorMessage = "Please upload both front and back images of Aadhar.";
      });
      return;
    }

    // Mark Aadhar as completed
    widget.onComplete(true);

    Navigator.pop(context, true); // ✅ Return true when Aadhar is completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("Aadhar Card Details"),
          backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload focused photos of your Aadhar Card for faster verification",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: aadharNumberController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: InputDecoration(
                labelText: "Enter 12-digit Aadhar Number",
                border: const OutlineInputBorder(),
                errorText:
                    errorMessage == "Aadhar number must be exactly 12 digits."
                        ? errorMessage
                        : null,
              ),
            ),
            const SizedBox(height: 10),
            _buildUploadField("Front side photo of your Aadhar card",
                frontAadhar, () => _pickImage(true)),
            _buildUploadField("Back side photo of your Aadhar card", backAadhar,
                () => _pickImage(false)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _submitAadhar,
              child: const Text("Next",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadField(String title, File? imageFile, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageFile != null
                ? Image.file(imageFile, fit: BoxFit.cover)
                : const Center(
                    child:
                        Icon(Icons.camera_alt, size: 40, color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

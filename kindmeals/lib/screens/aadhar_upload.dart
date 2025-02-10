import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AadharUploadPage extends StatefulWidget {
  @override
  _AadharUploadPageState createState() => _AadharUploadPageState();
}

class _AadharUploadPageState extends State<AadharUploadPage> {
  File? frontAadhar;
  File? backAadhar;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Aadhar Card Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Upload focused photos of your Aadhar Card for faster verification"),
            const SizedBox(height: 20),
            _buildUploadField("Front side photo of your Aadhar card",
                frontAadhar, () => _pickImage(true)),
            _buildUploadField("Back side photo of your Aadhar card", backAadhar,
                () => _pickImage(false)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (frontAadhar != null && backAadhar != null) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please upload both sides of Aadhaar")),
                  );
                }
              },
              child: const Text("Submit",
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

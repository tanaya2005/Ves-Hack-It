import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'driving_license_details.dart';

class PanCardDetailsPage extends StatefulWidget {
  final Function(bool) onComplete; // Accepts onComplete callback

  const PanCardDetailsPage({super.key, required this.onComplete});

  @override
  _PanCardDetailsPageState createState() => _PanCardDetailsPageState();
}

class _PanCardDetailsPageState extends State<PanCardDetailsPage> {
  final TextEditingController panNumberController = TextEditingController();
  File? _panCardImage;
  final picker = ImagePicker();
  String? errorMessage;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _panCardImage = File(pickedFile.path);
      });
    }
  }

  void _submitPanCard() {
    String panNumber = panNumberController.text;

    if (panNumber.isEmpty || panNumber.length != 10) {
      setState(() {
        errorMessage = "PAN number must be exactly 10 characters.";
      });
      return;
    }

    if (_panCardImage == null) {
      setState(() {
        errorMessage = "Please upload a photo of your PAN card.";
      });
      return;
    }

    // Mark as completed
    widget.onComplete(true);

    // Navigate to the next step (Driving License Page)
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("PAN Card Details"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload a focused photo of your PAN Card for faster verification",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: panNumberController,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Enter 10-digit PAN Number",
                border: const OutlineInputBorder(),
                errorText:
                    errorMessage == "PAN number must be exactly 10 characters."
                        ? errorMessage
                        : null,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload a picture of your PAN Card"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: _panCardImage == null
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
                  : Image.file(_panCardImage!,
                      height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPanCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

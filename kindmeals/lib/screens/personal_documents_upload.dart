import 'package:flutter/material.dart';
import 'package:kindmeals/screens/driving_license_details.dart';
import 'package:kindmeals/screens/pan_card_details.dart';
import 'aadhar_upload.dart';

class PersonalDocumentsUpload extends StatelessWidget {
  const PersonalDocumentsUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Documents")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload focused photos of below documents for faster verification",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Aadhar Card"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AadharUploadPage())),
            ),
            ListTile(
              title: const Text("PAN Card"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PanCardDetailsPage())),
            ),
            ListTile(
              title: const Text("Driving License"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrivingLicensePage())),
            ),
          ],
        ),
      ),
    );
  }
}

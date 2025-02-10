import 'package:flutter/material.dart';

class PanCardDetailsPage extends StatefulWidget {
  const PanCardDetailsPage({super.key});

  @override
  _PanCardDetailsPageState createState() => _PanCardDetailsPageState();
}

class _PanCardDetailsPageState extends State<PanCardDetailsPage> {
  bool hasPanCard = false;
  final TextEditingController panCardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAN Card Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Do you have a PAN Card?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: hasPanCard,
                  onChanged: (value) {
                    setState(() {
                      hasPanCard = true;
                    });
                  },
                ),
                const Text('Yes'),
                Radio(
                  value: false,
                  groupValue: hasPanCard,
                  onChanged: (value) {
                    setState(() {
                      hasPanCard = false;
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (hasPanCard)
              TextField(
                controller: panCardNumberController,
                decoration: const InputDecoration(
                  labelText: 'PAN Card Number',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!hasPanCard) {
                  Navigator.pushNamed(context, '/aadharUpload');
                } else {
                  Navigator.pushNamed(context, '/documentVerification');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

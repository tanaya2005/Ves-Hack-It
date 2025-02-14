import 'package:flutter/material.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Function(bool) onComplete;

  const VehicleDetailsPage({super.key, required this.onComplete});

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  void _submitDetails() {
    if (vehicleTypeController.text.isEmpty || vehicleNumberController.text.isEmpty) {
      _showError("Please fill in all the fields before submitting.");
      return;
    }

    widget.onComplete(true);
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: vehicleTypeController,
              decoration: const InputDecoration(labelText: 'Vehicle Type', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: vehicleNumberController,
              maxLength: 10,
              decoration: const InputDecoration(labelText: 'Vehicle Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDetails,
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

import 'package:flutter/material.dart';

class VehicleDetailsPage extends StatefulWidget {
  const VehicleDetailsPage({super.key});

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  bool hasVehicle = false;
  bool isEV = false;
  String? vehicleType;
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController evNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Do you have a vehicle?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: hasVehicle,
                  onChanged: (value) {
                    setState(() {
                      hasVehicle = true;
                    });
                  },
                ),
                const Text('Yes'),
                Radio(
                  value: false,
                  groupValue: hasVehicle,
                  onChanged: (value) {
                    setState(() {
                      hasVehicle = false;
                      isEV = false;
                      vehicleType = null;
                      vehicleNumberController.clear();
                      evNumberController.clear();
                    });
                  },
                ),
                const Text('No'),
              ],
            ),
            if (hasVehicle) ...[
              const SizedBox(height: 10),
              const Text('Vehicle Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: vehicleType,
                hint: const Text('Select Vehicle Type'),
                items: ['Bike', 'Car', 'EV']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleType = value;
                    isEV = value == 'EV';
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              if (!isEV)
                TextField(
                  controller: vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number Plate',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (isEV)
                TextField(
                  controller: evNumberController,
                  decoration: const InputDecoration(
                    labelText: 'EV Registration Number',
                    border: OutlineInputBorder(),
                  ),
                ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validation and Navigation Logic Here
                Navigator.pushNamed(context, '/registrationStatus');
              },
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

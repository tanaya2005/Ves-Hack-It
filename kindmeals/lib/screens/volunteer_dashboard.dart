import 'package:flutter/material.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Assigned Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Task ${index + 1}'),
                    subtitle: Text('Pickup from Donor ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

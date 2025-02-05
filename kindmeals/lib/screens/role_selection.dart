import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/donorDashboard');
              },
              child: Text('Register as Donor'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recipientDashboard');
              },
              child: Text('Register as Recipient'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/volunteerDashboard');
              },
              child: Text('Register as Volunteer'),
            ),
          ],
        ),
      ),
    );
  }
}

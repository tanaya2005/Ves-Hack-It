// TODO Implement this library.
import 'package:flutter/material.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Volunteer'), backgroundColor: Colors.green),
      body: const Center(child: Text('Volunteer for a cause.')),
    );
  }
}
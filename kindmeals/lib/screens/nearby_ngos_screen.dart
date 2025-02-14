// TODO Implement this library.
import 'package:flutter/material.dart';

class NearbyNGOsScreen extends StatelessWidget {
  const NearbyNGOsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby NGOs'), backgroundColor: Colors.green),
      body: const Center(child: Text('Find nearby NGOs.')),
    );
  }
}
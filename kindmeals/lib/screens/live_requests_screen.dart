// TODO Implement this library.
import 'package:flutter/material.dart';

class LiveRequestsScreen extends StatelessWidget {
  const LiveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Donation Requests'), backgroundColor: Colors.green),
      body: const Center(child: Text('View live donation requests.')),
    );
  }
}
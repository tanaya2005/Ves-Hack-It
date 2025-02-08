// TODO Implement this library.
import 'package:flutter/material.dart';

class CharityScreen extends StatelessWidget {
  const CharityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charity'), backgroundColor: Colors.green),
      body: const Center(child: Text('Support a charity.')),
    );
  }
}
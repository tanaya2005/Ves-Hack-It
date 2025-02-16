import 'package:flutter/material.dart';

class AllottedAreaScreen extends StatelessWidget {
  const AllottedAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Allotted Area"), backgroundColor: Colors.green),
      body: const Center(
        child: Text("Your allotted area is: XYZ Location",
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

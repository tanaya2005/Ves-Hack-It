// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class WelcomeSplashScreen extends StatelessWidget {
  const WelcomeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/registerLogin');
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to KindMeals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

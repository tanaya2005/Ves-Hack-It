import 'package:flutter/material.dart';

class RegisterLoginPage extends StatelessWidget {
  const RegisterLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup'); // Ensure this is correct
              },
              child: Text('Register'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Ensure this is correct
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

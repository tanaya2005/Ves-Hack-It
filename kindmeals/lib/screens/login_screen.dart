import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final role = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {'role': 'Donor'};

      if (role['role'] == 'Donor') {
        Navigator.pushReplacementNamed(context, '/donorDashboard');
      } else if (role['role'] == 'Recipient') {
        Navigator.pushReplacementNamed(context, '/recipientDashboard');
      } else if (role['role'] == 'Volunteer') {
        Navigator.pushReplacementNamed(context, '/volunteerDashboard');
      }
    }
  }

  void _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        Navigator.pushReplacementNamed(context, '/donorDashboard'); // Redirect after Google sign-in
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Email', controller: emailController),
              CustomTextField(label: 'Password', controller: passwordController, obscureText: true),
              SizedBox(height: 20),
              CustomButton(text: 'Login', onPressed: () => _login(context)),
              SizedBox(height: 10),
              Text('OR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Icon(Icons.account_circle),
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black, backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

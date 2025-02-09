import 'package:kindmeals/screens/language_selection.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'theme.dart';
import 'screens/welcome_splash.dart';
import 'screens/register_login.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/role_selection.dart';
import 'screens/chat_screen.dart';
import 'screens/otp_verification.dart';
import 'screens/dashboard.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const KindMealsApp());
  } catch (e) {
    print('Error initializing app: $e');
    // Show a more user-friendly error
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Error initializing app. Please check your connection.',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class KindMealsApp extends StatelessWidget {
  const KindMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KindMeals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home:
          LanguageSelectionPage(), // Start with your existing LanguageSelectionScreen
      routes: {
        '/welcome': (context) => WelcomeSplashScreen(),
        '/registerLogin': (context) => RegisterLoginPage(),
        '/login': (context) => LoginScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/roleSelection': (context) => RoleSelectionPage(),
        '/signup': (context) => RegisterScreen(),
        '/otpVerification': (context) => OTPVerificationScreen(),
        '/dashboard': (context) => Dashboard(),
        '/chatScreen': (context) => ChatScreen(
              recipientName: "Test User",
              onMessageSent: (String message) {},
            ),
      },
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // Fetch user data from Firestore on login
        _fetchUserData(user);
        // If the user is logged in, navigate to the dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // If not, navigate to the login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      var userData = userDoc.data();
      print("User Data: $userData");
      // Handle the user data, e.g., save it in a state variable
    } else {
      print("User data not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking authentication state
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await _auth.signOut();
        // After logging out, navigate to the register login screen
        Navigator.pushReplacementNamed(context, '/registerLogin');
      },
      child: Text('Log Out'),
    );
  }
}

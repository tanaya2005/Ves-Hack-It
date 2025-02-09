// ignore_for_file: use_build_context_synchronously, avoid_print
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kindmeals/screens/dashboard.dart';
import 'theme.dart';
import 'screens/language_selection.dart';
import 'screens/welcome_splash.dart';
import 'screens/register_login.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/role_selection.dart';
import 'screens/chat_screen.dart';
import 'screens/otp_verification.dart';

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
      home: Scaffold(
        backgroundColor: Colors.white,
        body: LanguageSelectionPage(),
      ),
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
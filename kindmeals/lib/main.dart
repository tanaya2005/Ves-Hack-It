import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/language_selection.dart';
import 'screens/welcome_splash.dart';
import 'screens/register_login.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/role_selection.dart';
import 'screens/donor_dashboard.dart';
import 'screens/recipient_dashboard.dart';
import 'screens/volunteer_dashboard.dart';
import 'screens/chat_screen.dart';
import 'screens/otp_verification.dart';

void main() {
  runApp(const KindMealsApp());
}

class KindMealsApp extends StatelessWidget {
  const KindMealsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KindMeals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LanguageSelectionPage(),
        '/welcome': (context) => WelcomeSplashScreen(),
        '/registerLogin': (context) => RegisterLoginPage(),
        '/login': (context) => LoginScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/roleSelection': (context) => RoleSelectionPage(),
        '/signup': (context) => RegisterScreen(),
        '/otpVerification': (context) => OTPVerificationScreen(),
        '/donorDashboard': (context) => DonorDashboard(),
        '/recipientDashboard': (context) => RecipientDashboard(),
        '/volunteerDashboard': (context) => VolunteerDashboard(),
        '/chatScreen': (context) => ChatScreen(recipientName: "Test User"),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kindmeals/screens/feedback_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kindmeals/screens/bank_account_details.dart';
import 'package:kindmeals/screens/driving_license_details.dart';
import 'package:kindmeals/screens/emergency_details.dart';
import 'package:kindmeals/screens/language_selection.dart';
import 'package:kindmeals/screens/pan_card_details.dart';
import 'package:kindmeals/screens/register_screen.dart';
import 'package:kindmeals/screens/vehicle_details.dart';
import 'package:kindmeals/screens/volunteer_login_page.dart';
import 'package:kindmeals/screens/volunteer_screen.dart';
import 'screens/volunteer_document_dashboard.dart';
import 'screens/personal_documents_upload.dart';
import 'screens/aadhar_upload.dart';
import 'screens/registration_status.dart';
import 'screens/welcome_splash.dart';
import 'screens/register_login.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/role_selection.dart';
import 'screens/chat_screen.dart';
import 'screens/dashboard.dart';
import 'theme.dart';
import 'screens/volunteer_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KindMealsApp());
}

class KindMealsApp extends StatelessWidget {
  const KindMealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KindMeals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LanguageSelectionPage(), // Language Selection as the first screen
      routes: {
        '/welcome': (context) => WelcomeSplashScreen(),
        '/registerLogin': (context) => RegisterLoginPage(),
        '/login': (context) => LoginScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/roleSelection': (context) => RoleSelection(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => Dashboard(),
        '/chatScreen': (context) => ChatScreen(
              recipientName: "Test User",
              onMessageSent: (String message) {},
            ),
        '/volunteer_dashboard': (context) => VolunteerScreen(),
        '/volunteer_document_dashboard': (context) =>
            VolunteerDocumentDashboard(),
        '/volunteerLogin': (context) => VolunteerLoginPage(),
        '/personalDocuments': (context) => const PersonalDocumentsUpload(),
        '/aadharUpload': (context) => AadharUploadPage(),
        '/registrationStatus': (context) => const RegistrationStatus(),
        '/vehicleDetails': (context) => const VehicleDetailsPage(),
        '/panCardDetails': (context) => const PanCardDetailsPage(),
        '/drivingLicenseDetails': (context) => const DrivingLicensePage(),
        '/bankAccountDetails': (context) => const BankAccountDetailsPage(),
        '/emergencyDetails': (context) => const EmergencyDetailsPage(),
        '/profile': (context) => const VolunteerProfileScreen(),
      },
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  String? userSession;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userSession = prefs.getString('volunteerSession');

    if (userSession != null) {
      Navigator.pushReplacementNamed(context, '/volunteer_dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/volunteerLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('volunteerSession');
    Navigator.pushReplacementNamed(context, '/volunteerLogin');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _logout(context),
      child: const Text('Log Out'),
    );
  }
}

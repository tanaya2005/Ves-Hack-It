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

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'theme.dart';
import 'screens/welcome_splash.dart';
import 'screens/register_login.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password.dart';
import 'screens/role_selection.dart';
import 'screens/chat_screen.dart';
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

  LogoutButton({super.key});

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

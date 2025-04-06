import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome_message': 'Welcome Back!',
      'login_to_account': 'Login to your account',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'login': 'Login',
      'continue_with_google': 'Continue with Google',
      'dont_have_account': 'Don\'t have an account?',
      'sign_up': 'Sign Up',
      'create_account': 'Create Account',
      'register_account': 'Register to your account',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'phone_number': 'Phone Number',
      'address': 'Address',
      'get_location': 'Tap to Get Current Location',
      'donor': 'Donor',
      'recipient': 'Recipient',
      'volunteer': 'Volunteer',
      'register': 'Register',
      'verify_email': 'Verify Email & Proceed',
      'sign_up_google': 'Sign Up with Google',
      'or': 'OR',
      'organization_name': 'Organization Name',
      'recipient_id': 'Recipient ID',
      'about_you': 'About You',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी',
      'tell_us_about_yourself': 'Tell us about yourself',
      'Kindmeals_Dashboard': 'Kindmeals Dashboard',
      'post_donation': 'Post Donation',
      'live_donation_requests': 'Live Donation Requests',
      'charity': 'Charity',
      'nearby_ngos': 'Nearby NGOs',
      'volunteer_profile': 'Volunteer',
      'track_delivery': 'Track Delivery',
    },
    'hi': {
      'welcome_message': 'वापसी पर स्वागत है!',
      'login_to_account': 'अपने खाते में लॉग इन करें',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड भूल गए?',
      'login': 'लॉग इन',
      'continue_with_google': 'Google के साथ जारी रखें',
      'dont_have_account': 'खाता नहीं है?',
      'sign_up': 'साइन अप करें',
      'create_account': 'खाता बनाएं',
      'register_account': 'अपना खाता रजिस्टर करें',
      'full_name': 'पूरा नाम',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'phone_number': 'फ़ोन नंबर',
      'address': 'पता',
      'get_location': 'वर्तमान स्थान प्राप्त करने के लिए टैप करें',
      'donor': 'दाता',
      'recipient': 'प्राप्तकर्ता',
      'volunteer': 'स्वयंसेवक',
      'register': 'रजिस्टर करें',
      'verify_email': 'ईमेल सत्यापित करें और आगे बढ़ें',
      'sign_up_google': 'Google के साथ साइन अप करें',
      'or': 'या',
      'organization_name': 'संगठन का नाम',
      'recipient_id': 'प्राप्तकर्ता आईडी',
      'about_you': 'आपके बारे में',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी',
      'tell_us_about_yourself': 'हमें अपने बारे में बताएं',
      'Kindmeals_Dashboard': 'Kindmeals डैशबोर्ड',
      'post_donation': 'डोनेशन पोस्ट करें',
      'live_donation_requests': 'लाइव डोनेशन अनुरोध',
      'charity': 'चैरिटी',
      'nearby_ngos': 'नजदीकी एनजीओ',
      'volunteer_profile': 'स्वयंसेवक',
      'track_delivery': 'वितरण का पता लगाएं',

    },
  };

  String get welcomeMessage =>
      _localizedValues[locale.languageCode]!['welcome_message']!;
  String get loginToAccount =>
      _localizedValues[locale.languageCode]!['login_to_account']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]!['forgot_password']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get continueWithGoogle =>
      _localizedValues[locale.languageCode]!['continue_with_google']!;
  String get dontHaveAccount =>
      _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get signUp => _localizedValues[locale.languageCode]!['sign_up']!;
  String get createAccount =>
      _localizedValues[locale.languageCode]!['create_account']!;
  String get registerAccount =>
      _localizedValues[locale.languageCode]!['register_account']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get confirmPassword =>
      _localizedValues[locale.languageCode]!['confirm_password']!;
  String get phoneNumber =>
      _localizedValues[locale.languageCode]!['phone_number']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get getLocation =>
      _localizedValues[locale.languageCode]!['get_location']!;
  String get donor => _localizedValues[locale.languageCode]!['donor']!;
  String get recipient => _localizedValues[locale.languageCode]!['recipient']!;
  String get volunteer => _localizedValues[locale.languageCode]!['volunteer']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get verifyEmail =>
      _localizedValues[locale.languageCode]!['verify_email']!;
  String get signUpGoogle =>
      _localizedValues[locale.languageCode]!['sign_up_google']!;
  String get or => _localizedValues[locale.languageCode]!['or']!;
  String get organizationName =>
      _localizedValues[locale.languageCode]!['organization_name']!;
  String get recipientId =>
      _localizedValues[locale.languageCode]!['recipient_id']!;
  String get aboutYou => _localizedValues[locale.languageCode]!['about_you']!;
  String get selectLanguage =>
      _localizedValues[locale.languageCode]!['select_language']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get hindi => _localizedValues[locale.languageCode]!['hindi']!;
  String get tellUsAboutYourself =>
      _localizedValues[locale.languageCode]!['tell_us_about_yourself']!;
  String get KindmealsDashboard =>
      _localizedValues[locale.languageCode]!['Kindmeals_Dashboard']!;
  String get postDonation =>
      _localizedValues[locale.languageCode]!['post_donation']!;
  String get liveDonationRequests =>
      _localizedValues[locale.languageCode]!['live_donation_requests']!;
  String get charity => _localizedValues[locale.languageCode]!['charity']!;
  String get nearbyNgos =>
      _localizedValues[locale.languageCode]!['nearby_ngos']!;
  String get volunteerProfile =>
      _localizedValues[locale.languageCode]!['volunteer_profile']!;
  String get trackDelivery =>
      _localizedValues[locale.languageCode]!['track_delivery']!;
      
}
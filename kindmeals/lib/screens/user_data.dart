// user_data.dart
class UserData {
  static String? userRole;
  static String? userName;
  static String? userEmail;
  static String? userPhone;
  static String? userLocation;
  static String? userOrganization;
  static String? userRecipientId;
  static String? userAbout;

  static void setUserData(Map<String, dynamic> userData, String role) {
    userRole = role;
    userName = userData['name'];
    userEmail = userData['email'];
    userPhone = userData['phone'];
    userLocation = userData['location'];
    if (role == 'donor') {
      userOrganization = userData['organization'];
    } else {
      userRecipientId = userData['recipientId'];
      userAbout = userData['about'];
    }
  }

  static void clearUserData() {
    userRole = null;
    userName = null;
    userEmail = null;
    userPhone = null;
    userLocation = null;
    userOrganization = null;
    userRecipientId = null;
    userAbout = null;
  }
}
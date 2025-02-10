import 'package:flutter/material.dart';
import 'package:kindmeals/screens/login_screen.dart';
// import 'package:kindmeals/screens/register_login.dart';
// import 'package:kindmeals/screens/role_selection.dart';
import 'package:kindmeals/screens/settings_screen.dart';
import 'edit_profile_screen.dart'; // Import the EditProfileScreen
import 'change_password_screen.dart'; // Import the ChangePasswordScreen
// import 'login_screen.dart'; // Import LoginScreen

class ProfileScreen extends StatefulWidget {
  final bool isVolunteer;

  const ProfileScreen({super.key, this.isVolunteer = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Bhuki Margret';
  String email = 'khanadedo@ngo.com';
  String phone = '99999922288';
  String location = 'Shaitaan Gali, Khatra Mahal, Shamsaan ke saamne';
  String organization = 'Helping Hands';
  String about = 'We are here to help.';
  String currentPassword = 'password123'; // Placeholder for current password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigate to Settings Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA8wdinI12oeDwYnTw1KE96jlZDywL_doY_A&s',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileSection('Account Details', [
              _buildInfoRow(Icons.phone, 'Phone', phone),
              _buildInfoRow(Icons.location_on, 'Location', location),
              _buildInfoRow(Icons.business, 'Organization', organization),
              _buildInfoRow(Icons.info, 'About', about),
            ]),
            const SizedBox(height: 16),
            _buildProfileSection(
              'Settings',
              [
                _buildSettingsTile(Icons.edit, 'Edit Profile', () async {
                  final updatedProfile = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        name: name,
                        email: email,
                        phone: phone,
                        location: location,
                        organization: organization,
                        about: about,
                      ),
                    ),
                  );

                  if (updatedProfile != null) {
                    setState(() {
                      name = updatedProfile['name'];
                      email = updatedProfile['email'];
                      phone = updatedProfile['phone'];
                      location = updatedProfile['location'];
                      organization = updatedProfile['organization'];
                      about = updatedProfile['about'];
                    });
                  }
                }),
                _buildSettingsTile(Icons.lock, 'Change Password', () async {
                  final newPassword = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(
                          currentPassword: currentPassword),
                    ),
                  );

                  if (newPassword != null) {
                    setState(() {
                      currentPassword = newPassword;
                    });
                  }
                }),
                _buildSettingsTile(Icons.language, 'Language Preferences', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Select Language'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text('English'),
                              onTap: () {
                                // Implement language change
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('Hindi'),
                              onTap: () {
                                // Implement language change
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                _buildSettingsTile(Icons.logout, 'Logout', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Navigate to LoginScreen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),
            if (widget.isVolunteer) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Volunteer Dashboard
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Volunteer Dashboard',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

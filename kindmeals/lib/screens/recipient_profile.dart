import 'package:flutter/material.dart';
import 'edit_recipient_profile.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'user_data.dart';

class RecipientProfile extends StatefulWidget {
  const RecipientProfile({super.key});

  @override
  State<RecipientProfile> createState() => _RecipientProfileState();
}

class _RecipientProfileState extends State<RecipientProfile> {
  String currentPassword = 'password123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipient Profile'),
        backgroundColor: Colors.blue,
      ),
      body: _buildProfileContent(context),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileSection('Account Details', [
            _buildInfoRow(Icons.phone, 'Phone', UserData.userPhone ?? 'Not set'),
            _buildInfoRow(Icons.location_on, 'Location', UserData.userLocation ?? 'Not set'),
            _buildInfoRow(Icons.account_box, 'Recipient ID', UserData.userRecipientId ?? 'Not set'),
            _buildInfoRow(Icons.info, 'About', UserData.userAbout ?? 'Not set'),
          ]),
          const SizedBox(height: 16),
          _buildProfileSection('Settings', [
            _buildSettingsTile(Icons.edit, 'Edit Profile', () async {
              final updatedProfile = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipientProfileScreen(
                    name: UserData.userName ?? '',
                    email: UserData.userEmail ?? '',
                    phone: UserData.userPhone ?? '',
                    location: UserData.userLocation ?? '',
                    recipientId: UserData.userRecipientId ?? '',
                    about: UserData.userAbout ?? '',
                  ),
                ),
              );

              if (updatedProfile != null) {
                setState(() {
                  UserData.userName = updatedProfile['name'];
                  UserData.userEmail = updatedProfile['email'];
                  UserData.userPhone = updatedProfile['phone'];
                  UserData.userLocation = updatedProfile['location'];
                  UserData.userRecipientId = updatedProfile['recipientId'];
                  UserData.userAbout = updatedProfile['about'];
                });
              }
            }),
            _buildSettingsTile(Icons.lock, 'Change Password', () async {
              final newPassword = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(currentPassword: currentPassword),
                ),
              );

              if (newPassword != null) {
                setState(() {
                  currentPassword = newPassword;
                });
              }
            }),
            _buildSettingsTile(Icons.logout, 'Logout', () {
              _showLogoutDialog(context);
            }),
          ]),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            UserData.userName ?? 'No Name',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            UserData.userEmail ?? 'No Email',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
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
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                UserData.clearUserData();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
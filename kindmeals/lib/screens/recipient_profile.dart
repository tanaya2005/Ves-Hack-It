import 'package:flutter/material.dart';
import 'edit_recipient_profile.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';

class RecipientProfile extends StatefulWidget {
  const RecipientProfile({super.key});

  @override
  State<RecipientProfile> createState() => _RecipientProfileState();
}

class _RecipientProfileState extends State<RecipientProfile> {
  String name = 'Jane Smith';
  String email = 'janesmith@recipient.com';
  String phone = '9876543210';
  String location = 'Hope Avenue, Charity City';
  String recipientId = 'R123456';
  String about = 'Committed to improving lives through your generosity.';
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
            _buildInfoRow(Icons.phone, 'Phone', phone),
            _buildInfoRow(Icons.location_on, 'Location', location),
            _buildInfoRow(Icons.account_box, 'Recipient ID', recipientId),
            _buildInfoRow(Icons.info, 'About', about),
          ]),
          const SizedBox(height: 16),
          _buildProfileSection('Settings', [
            _buildSettingsTile(Icons.edit, 'Edit Profile', () async {
              final updatedProfile = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipientProfileScreen(
                    name: name,
                    email: email,
                    phone: phone,
                    location: location,
                    recipientId: recipientId,
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
                  recipientId = updatedProfile['recipientId'];
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
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
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

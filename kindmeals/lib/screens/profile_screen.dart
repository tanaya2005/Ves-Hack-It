import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isVolunteer;

  const ProfileScreen({super.key, this.isVolunteer = false});

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
              // Navigate to Chat Screen
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
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA8wdinI12oeDwYnTw1KE96jlZDywL_doY_A&s',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bhuki Margret',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'khanadedo@ngo.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileSection('Account Details', [
              _buildInfoRow(Icons.phone, 'Phone', '99999922288'),
              _buildInfoRow(Icons.location_on, 'Location', 'Shaitaan Gali, Khatra Mahal, Shamsaan ke saamne'),
              _buildInfoRow(Icons.business, 'Organization', 'Helping Hands'),
              _buildInfoRow(Icons.info, 'About', 'We are here to help.'),
            ]),
            const SizedBox(height: 16),
            _buildProfileSection('Settings', [
              _buildSettingsTile(Icons.edit, 'Edit Profile', () {}),
              _buildSettingsTile(Icons.lock, 'Change Password', () {}),
              _buildSettingsTile(Icons.language, 'Language Preferences', () {}),
              _buildSettingsTile(Icons.logout, 'Logout', () {}),
            ]),
            if (isVolunteer) ...[
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

import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'allotted_area.dart';
import 'support.dart';
import 'terms_conditions.dart';
import 'privacy_policy.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Profile selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
                context, '/ordersPage'); // To be implemented
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profile_pic.png'), // Change this to network image if needed
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Aman Sharma',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            '+91 9999988888',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Text(
            'loremipsum@gmail.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          _buildProfileOption(
            context,
            icon: Icons.edit,
            title: "Edit Profile",
            destination: const EditProfileScreen(),
          ),
          _buildProfileOption(
            context,
            icon: Icons.location_on,
            title: "Allotted Area",
            destination: const AllottedAreaScreen(),
          ),
          _buildProfileOption(
            context,
            icon: Icons.support_agent,
            title: "Support",
            destination: const SupportScreen(),
          ),
          _buildProfileOption(
            context,
            icon: Icons.article,
            title: "Terms and Conditions",
            destination: const TermsConditionsScreen(),
          ),
          _buildProfileOption(
            context,
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            destination: const PrivacyPolicyScreen(),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () {
              _logout(context);
            },
          ),
          const Spacer(),
          const Text(
            "App Version 1.0.0 (30)",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      required Widget destination}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // Implement logout logic
    Navigator.pushReplacementNamed(context, '/registerLogin');
  }
}

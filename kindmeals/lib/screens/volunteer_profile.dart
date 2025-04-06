import 'package:flutter/material.dart';
import 'edit_volunteer_profile.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/download.jpeg'),
                ),
              ),
              Positioned(
                right: 30,
                top: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "4.9",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.star, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
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
            icon: Icons.edit,
            title: "Edit Profile",
            destination: const EditProfileScreen(),
          ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomNavButton(
              context,
              icon: Icons.list,
              label: "Orders",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/volunteersOrderPage');
              },
            ),
            _bottomNavButton(
              context,
              icon: Icons.person,
              label: "Account",
              onPressed: () {
                // Already on account page
              },
            ),
          ],
        ),
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

  Widget _bottomNavButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.green),
        label: Text(label, style: const TextStyle(color: Colors.green)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: const BorderSide(color: Colors.green),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }
}


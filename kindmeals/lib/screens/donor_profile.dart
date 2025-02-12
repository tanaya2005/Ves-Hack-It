// import 'package:flutter/material.dart';
// import 'edit_donor_profile.dart';
// import 'change_password_screen.dart';
// import 'login_screen.dart';

// class DonorProfile extends StatefulWidget {
//   const DonorProfile({super.key});

//   @override
//   State<DonorProfile> createState() => _DonorProfileState();
// }

// class _DonorProfileState extends State<DonorProfile> {
//   String name = 'John Doe';
//   String email = 'johndoe@donor.com';
//   String phone = '1234567890';
//   String location = 'Donor Street, Kind Town';
//   String organization = 'Giving Hearts';
//   String about = 'Dedicated to making a difference.';
//   String currentPassword = 'password123';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Donor Profile'),
//         backgroundColor: Colors.green,
//       ),
//       body: _buildProfileContent(context),
//     );
//   }

//   Widget _buildProfileContent(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildProfileHeader(),
//           const SizedBox(height: 24),
//           _buildProfileSection('Account Details', [
//             _buildInfoRow(Icons.phone, 'Phone', phone),
//             _buildInfoRow(Icons.location_on, 'Location', location),
//             _buildInfoRow(Icons.business, 'Organization', organization),
//             _buildInfoRow(Icons.info, 'About', about),
//           ]),
//           const SizedBox(height: 16),
//           _buildProfileSection('Settings', [
//             _buildSettingsTile(Icons.edit, 'Edit Profile', () async {
//               final updatedProfile = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EditDonorProfileScreen(
//                     name: name,
//                     email: email,
//                     phone: phone,
//                     location: location,
//                     organization: organization,
//                     about: about,
//                   ),
//                 ),
//               );

//               if (updatedProfile != null) {
//                 setState(() {
//                   name = updatedProfile['name'];
//                   email = updatedProfile['email'];
//                   phone = updatedProfile['phone'];
//                   location = updatedProfile['location'];
//                   organization = updatedProfile['organization'];
//                   about = updatedProfile['about'];
//                 });
//               }
//             }),
//             _buildSettingsTile(Icons.lock, 'Change Password', () async {
//               final newPassword = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChangePasswordScreen(
//                       currentPassword: currentPassword),
//                 ),
//               );

//               if (newPassword != null) {
//                 setState(() {
//                   currentPassword = newPassword;
//                 });
//               }
//             }),
//             _buildSettingsTile(Icons.logout, 'Logout', () {
//               _showLogoutDialog(context);
//             }),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Center(
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 50,
//             backgroundImage: NetworkImage(
//               'https://via.placeholder.com/150',
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             name,
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             email,
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileSection(String title, List<Widget> children) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         ...children,
//       ],
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(label),
//       subtitle: Text(value),
//     );
//   }

//   Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.green),
//       title: Text(title),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: onTap,
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Are you sure you want to log out?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text(
//                   'Yes',
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_donor_profile.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'api_service.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = '';
  String email = '';
  String phone = '';
  String location = '';
  String organization = '';
  String about = 'Dedicated to making a difference.';
  String currentPassword = '';
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // Delay the fetch until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDonorProfile();
    });
  }

  Future<void> _fetchDonorProfile() async {
    try {
      // Get current user from Firebase
      final User? user = _auth.currentUser;

      if (user == null) {
        setState(() {
          error = 'No user logged in';
          isLoading = false;
        });
        return;
      }

      final response = await ApiService.getDonorProfile(user.email!);

      setState(() {
        name = response['name'] ?? '';
        email = response['email'] ?? '';
        phone = response['phone'] ?? '';
        location = response['location'] ?? '';
        organization = response['organization'] ?? '';
        currentPassword = response['currentPassword'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load profile: $e';
        isLoading = false;
      });
      print('Error fetching profile: $e'); // For debugging
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // This removes all previous routes
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Profile'),
        backgroundColor: Colors.green,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchDonorProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return _buildProfileContent(context);
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
            _buildInfoRow(Icons.business, 'Organization', organization),
            _buildInfoRow(Icons.info, 'About', about),
          ]),
          const SizedBox(height: 16),
          _buildProfileSection('Settings', [
            _buildSettingsTile(Icons.edit, 'Edit Profile', () async {
              final updatedProfile = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditDonorProfileScreen(
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
                  builder: (context) =>
                      ChangePasswordScreen(currentPassword: currentPassword),
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

  // Rest of the widget methods remain the same...
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
            ),
          ],
        );
      },
    );
  }
}

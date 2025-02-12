import 'package:flutter/material.dart';
import 'package:kindmeals/screens/donation_history_screen.dart';
import 'package:kindmeals/screens/donor_profile.dart';
import 'package:kindmeals/screens/notification_screen.dart';
import 'package:kindmeals/screens/recipient_profile.dart';
import 'package:kindmeals/screens/user_role.dart';
import 'chat_screen.dart';
import 'post_donation_screen.dart';
import 'live_requests_screen.dart';
import 'charity_screen.dart';
import 'nearby_ngos_screen.dart';
import 'volunteer_screen.dart';
import 'track_delivery_screen.dart';

// // Dummy data for recent chats
// class RecentChat {
//   final String recipientName;
//   final String lastMessage;
//   final String time;

//   RecentChat({
//     required this.recipientName,
//     required this.lastMessage,
//     required this.time,
//   });
// }

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KindMeals Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(Icons.food_bank, 'Post Donation', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PostDonationScreen()));
            }),
            _buildDashboardCard(Icons.request_page, 'Live Donation Requests', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LiveDonationRequestsScreen()));
            }),
            _buildDashboardCard(Icons.monetization_on, 'Charity', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CharityScreen()));
            }),
            _buildDashboardCard(Icons.location_on, 'Nearby NGOs', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyNGOsScreen()));
            }),
            _buildDashboardCard(Icons.volunteer_activism, 'Volunteer', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteerScreen()));
            }),
            _buildDashboardCard(Icons.delivery_dining, 'Track Delivery', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackDeliveryScreen()));
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the recent chats screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecentChatsScreen(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'KindMeals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                if (userRole == "donor") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DonorProfile(), // Navigate to DonorProfile
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecipientProfile(), // Navigate to RecipientProfile
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DonationHistoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Support'),
              onTap: () {
                // Implement Support screen navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('FAQs'),
              onTap: () {
                // Implement FAQs screen navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                // Implement Privacy Policy screen navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Terms and Conditions'),
              onTap: () {
                // Implement Terms and Conditions screen navigation
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('KindMeals © 2025'),
              onTap: () {
                // Optionally handle the copyright action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Colors.lightGreen[100],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.green[800]),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // Recent Chats Screen
// class RecentChatsScreen extends StatelessWidget {
//   const RecentChatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<RecentChat> recentChats = [
//       RecentChat(recipientName: 'Donor 1', lastMessage: 'Looking forward to your help.', time: '10:30 AM'),
//       RecentChat(recipientName: 'Donor 2', lastMessage: 'I will deliver the food soon.', time: '9:15 AM'),
//       RecentChat(recipientName: 'Donor 3', lastMessage: 'I have confirmed the donation.', time: 'Yesterday'),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recent Chats'),
//         backgroundColor: Colors.green,
//       ),
//       body: ListView.builder(
//         itemCount: recentChats.length,
//         itemBuilder: (context, index) {
//           final chat = recentChats[index];
//           return ListTile(
//             onTap: () {
//               // Navigate to the chat screen with the recipient's name
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(recipientName: chat.recipientName, onMessageSent: (String message) { }),
//                 ),
//               );
//             },
//             leading: CircleAvatar(
//               backgroundColor: Colors.green, // First letter of recipient name
//               foregroundColor: Colors.white,
//               child: Text(chat.recipientName[0]),
//             ),
//             title: Text(chat.recipientName),
//             subtitle: Text(chat.lastMessage),
//             trailing: Text(chat.time),
//           );
//         },
//       ),
//     );
//   }
// }

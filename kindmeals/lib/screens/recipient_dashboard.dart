// // recipient_dashboard.dart
// import 'package:flutter/material.dart';
// import 'live_requests_screen.dart';
// import 'nearby_ngos_screen.dart';
// import 'volunteer_screen.dart';
// import 'track_delivery_screen.dart';
// import 'notification_screen.dart';
// import 'profile_screen.dart';
// import 'chat_screen.dart';

// class RecipientDashboard extends StatelessWidget {
//   const RecipientDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recipient Dashboard'),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildDashboardCard(Icons.request_page, 'Live Requests', () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => LiveDonationRequestsScreen()));
//             }),
//             _buildDashboardCard(Icons.location_on, 'Nearby NGOs', () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyNGOsScreen()));
//             }),
//             _buildDashboardCard(Icons.volunteer_activism, 'Volunteer', () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const VolunteerScreen()));
//             }),
//             _buildDashboardCard(Icons.delivery_dining, 'Track Delivery', () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackDeliveryScreen()));
//             }),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => RecentChatsScreen(),
//             ),
//           );
//         },
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.chat),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         type: BottomNavigationBarType.fixed,
//         onTap: (index) {
//           if (index == 1) {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
//           } else if (index == 2) {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   Widget _buildDashboardCard(IconData icon, String title, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 4,
//         color: Colors.lightGreen[100],
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 50, color: Colors.green[800]),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

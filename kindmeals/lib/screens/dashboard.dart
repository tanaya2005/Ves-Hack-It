import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'post_donation_screen.dart';
import 'live_requests_screen.dart';
import 'charity_screen.dart';
import 'nearby_ngos_screen.dart';
import 'volunteer_screen.dart';
import 'track_delivery_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KindMeals Dashboard'),
        backgroundColor: Colors.green,
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveRequestsScreen()));
            }),
            _buildDashboardCard(Icons.monetization_on, 'Charity', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CharityScreen()));
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(recipientName: 'Varun'),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
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
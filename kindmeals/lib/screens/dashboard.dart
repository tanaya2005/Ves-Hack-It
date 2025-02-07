import 'package:flutter/material.dart';

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
            _buildDashboardCard(
              Icons.food_bank,
              'Post Donation',
              () {
                // Navigate to Post Donation screen
              },
            ),
            _buildDashboardCard(
              Icons.request_page,
              'Live Donation Requests',
              () {
                // Navigate to Requests screen
              },
            ),
            _buildDashboardCard(
              Icons.location_on,
              'Nearby Donors',
              () {
                // Navigate to Nearby NGOs/Donors screen
              },
            ),
            _buildDashboardCard(
              Icons.location_on,
              'Nearby NGOs',
              () {
                // Navigate to Nearby NGOs/Donors screen
              },
            ),
            _buildDashboardCard(
              Icons.volunteer_activism,
              'Volunteer',
              () {
                // Navigate to Volunteers screen
              },
            ),
            _buildDashboardCard(
              Icons.chat,
              'Chat',
              () {
                // Navigate to Chat screen
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed, // Set the initial selected index
        onTap: (index) {
          // Handle bottom navigation tap
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
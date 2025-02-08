import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Donor Notifications
            _buildSectionHeader('Donor Notifications'),
            _buildNotificationCard(
                context, 'Food Expiry Reminder', 'Your donation is about to expire in 1 hour.'),
            _buildNotificationCard(context, 'Donation Request Accepted', 'Your donation request has been accepted by the recipient.'),
            _buildNotificationCard(context, 'Expired Food Alert', 'The food you donated has expired and cannot be accepted.'),

            // Recipient Notifications
            _buildSectionHeader('Recipient Notifications'),
            _buildNotificationCard(
                context, 'Donation Request Confirmation', 'You have successfully accepted the donation request.'),
            _buildNotificationCard(
                context, 'Feedback from Donor', 'The donor has left feedback about your donation acceptance.'),
            
            // Both Donor and Recipient Notifications
            _buildSectionHeader('General Notifications'),
            _buildNotificationCard(
                context, 'Volunteer Pickup/Delivery Request', 'A volunteer is approaching for your pickup/delivery request.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, String title, String message) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: Icon(Icons.notifications, color: Colors.green),
        onTap: () {
          // Handle tap (navigate to specific screen based on notification type, if needed)
          print('Tapped on: $title');
        },
      ),
    );
  }
}

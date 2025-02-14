// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation History'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Donor Donation History
            _buildSectionHeader('Donor Donation History'),
            _buildHistoryCard(context, 'Donation to XYZ Hospital', 'Accepted', '2 hours ago', 'Food donated: 10 boxes'),
            _buildHistoryCard(context, 'Donation to ABC Shelter', 'Expired', '1 day ago', 'Food donated: 15 boxes'),

            // Recipient Donation History
            _buildSectionHeader('Recipient Donation History'),
            _buildHistoryCard(context, 'Donation from John Doe', 'Received', '3 hours ago', 'Food received: 8 boxes'),
            _buildHistoryCard(context, 'Donation from Jane Smith', 'Expired', '2 days ago', 'Food received: 5 boxes'),

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

  Widget _buildHistoryCard(BuildContext context, String title, String status, String time, String details) {
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: $status',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              'Time: $time',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              details,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        trailing: Icon(Icons.history, color: Colors.green),
        onTap: () {
          // Handle tap (e.g., navigate to a detailed history screen or any relevant action)
          print('Tapped on: $title');
        },
      ),
    );
  }
}

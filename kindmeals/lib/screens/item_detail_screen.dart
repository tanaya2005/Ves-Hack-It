import 'package:flutter/material.dart';
import 'package:kindmeals/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map<String, String> request;

  const ItemDetailScreen({super.key, required this.request});

  Future<void> _openMap(double latitude, double longitude) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open map';
    }
  }

  @override
  Widget build(BuildContext context) {
    double latitude = double.parse(request['latitude']!);
    double longitude = double.parse(request['longitude']!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.network(
              request['image'] ?? 'https://i.ytimg.com/vi/fx3mg1ow3HA/maxresdefault.jpg',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              'Food Name: ${request['foodName']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${request['quantity']}'),
            const SizedBox(height: 8),
            Text('Expiration Date: ${request['expirationDate']}'),
            const SizedBox(height: 8),
            Text('Description: ${request['description']}'),
            const SizedBox(height: 8),
            Text('Location: ${request['location']}'),
            const SizedBox(height: 8),
            Text('Donor Name: ${request['donorName']}'),
            const SizedBox(height: 8),
            Text('Donor Verification: ${request['donorVerification']}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(recipientName: 'Donor'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text(
                'Chat with Donor',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _openMap(latitude, longitude),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 60),
              ),
              child: const Text(
                'Get Directions to Donor',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
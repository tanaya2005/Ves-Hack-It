import 'package:flutter/material.dart';
import 'package:kindmeals/screens/chat_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map<String, String> request;

  const ItemDetailScreen({super.key, required this.request});


  @override
  Widget build(BuildContext context) {
    double.parse(request['latitude']!);
    double.parse(request['longitude']!);

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
              request['image'] ??
                  'https://i.ytimg.com/vi/fx3mg1ow3HA/maxresdefault.jpg',
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
                    builder: (context) => ChatScreen(
                        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                        recipientName: request['donorName'] ?? 'Donor', onMessageSent: (String ) {  },),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Text(
                'Chat with ${request['donorName'] ?? 'Donor'}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

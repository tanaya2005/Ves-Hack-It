import 'package:flutter/material.dart';
import 'chat_screen.dart';

class RecipientDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> liveDonations = [
    {'title': '20kg Rice', 'donor': 'John Doe', 'location': 'Mumbai'},
    {'title': '10kg Vegetables', 'donor': 'Food Store', 'location': 'Pune'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipient Dashboard')),
      body: ListView.builder(
        itemCount: liveDonations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(liveDonations[index]['title']),
              subtitle: Text('Donor: ${liveDonations[index]['donor']}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(liveDonations[index]['title']),
                    content: Text('Donor: ${liveDonations[index]['donor']}\nLocation: ${liveDonations[index]['location']}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(recipientName: liveDonations[index]['donor']),
                            ),
                          );
                        },
                        child: Text('Accept & Chat'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

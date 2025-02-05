import 'package:flutter/material.dart';
import 'chat_screen.dart'; // ✅ Import Chat Screen

class RecipientDashboard extends StatelessWidget {
  const RecipientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> liveDonations = [
      {'title': '20kg Rice', 'donor': 'John Doe', 'location': 'Mumbai'},
      {'title': '10kg Vegetables', 'donor': 'Food Store', 'location': 'Pune'},
    ];

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
                    content: Text(
                        'Donor: ${liveDonations[index]['donor']}\nLocation: ${liveDonations[index]['location']}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close Dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                recipientName: liveDonations[index]['donor'], // ✅ Pass Donor Name
                              ),
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

import 'package:flutter/material.dart';

class CharityScreen extends StatelessWidget {
  CharityScreen({super.key});

  // Sample list of charities, you can replace this with dynamic data from your backend.
  final List<Map<String, String>> charities = [
    {'name': 'Food for All', 'description': 'Help us provide food to those in need.'},
    {'name': 'Education for Children', 'description': 'Sponsor a child\'s education.'},
    {'name': 'Medical Aid', 'description': 'Support those with medical needs.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charity'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Support a Charity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose a charity to support and make a difference.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: charities.length,
                itemBuilder: (context, index) {
                  return CharityCard(
                    name: charities[index]['name']!,
                    description: charities[index]['description']!,
                    onTap: () {
                      // You can navigate to a detailed charity page or donation page here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Supporting: ${charities[index]['name']}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharityCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const CharityCard({
    super.key,
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.green),
        onTap: onTap,
      ),
    );
  }
}

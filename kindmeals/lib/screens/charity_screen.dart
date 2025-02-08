import 'package:flutter/material.dart';

class CharityScreen extends StatefulWidget {
  const CharityScreen({super.key});

  @override
  _CharityScreenState createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  String amount = '';
  String paymentMethod = 'upi';

  void handleAmountClick(String value) {
    setState(() {
      amount = value;
    });
  }

  void handleDonate() {
    if (amount.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Thank you for donating ₹$amount via ${paymentMethod.toUpperCase()}! ❤'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter or select an amount to donate.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Charity Donation'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help the Needy, Donate Today ❤',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your small contribution can make a big difference in someone\'s life.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Donation Amount Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => handleAmountClick('100'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ), // Highlight the button
                    child: const Text('₹100'),
                  ),
                  ElevatedButton(
                    onPressed: () => handleAmountClick('500'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('₹500'),
                  ),
                  ElevatedButton(
                    onPressed: () => handleAmountClick('1000'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('₹1000'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Custom Amount Input
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Custom Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Impact Section
              const Text(
                'How Your Donation Helps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('💖 ₹100 - Provides a meal for a family in need.'),
              const Text(
                  '📚 ₹500 - Supports education for an underprivileged child.'),
              const Text(
                  '🏥 ₹1000 - Helps fund medical assistance for the needy.'),
              const SizedBox(height: 20),

              // Payment Method Selection
              const Text(
                'Select Payment Method:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('UPI'),
                leading: Radio(
                  value: 'upi',
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value.toString();
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Credit/Debit Card'),
                leading: Radio(
                  value: 'credit-debit',
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value.toString();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Donate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleDonate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      const Text('Donate Now', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

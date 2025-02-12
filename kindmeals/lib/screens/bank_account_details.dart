import 'package:flutter/material.dart';

class BankAccountDetailsPage extends StatefulWidget {
  final Function(bool) onComplete;

  const BankAccountDetailsPage({super.key, required this.onComplete});

  @override
  BankAccountDetailsPageState createState() => BankAccountDetailsPageState();
}

class BankAccountDetailsPageState extends State<BankAccountDetailsPage> {
  final _formKey = GlobalKey<FormState>(); // ✅ Added form key for validation

  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController volunteerNameController = TextEditingController();

  void _submitDetails() {
    if (_formKey.currentState!.validate()) { // ✅ Validate form before submission
      widget.onComplete(true); // ✅ Mark as completed
      Navigator.pop(context); // ✅ Navigate back to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Account Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // ✅ Wrap with Form widget
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your Bank Account Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Bank Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Bank Name'
                    : null, // ✅ Validation
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: branchNameController,
                decoration: const InputDecoration(
                  labelText: 'Branch Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Branch Name'
                    : null, // ✅ Validation
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Account Number'
                    : null, // ✅ Validation
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ifscCodeController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter IFSC Code'
                    : null, // ✅ Validation
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: volunteerNameController,
                decoration: const InputDecoration(
                  labelText: 'Account Holder Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter Account Holder Name'
                    : null, // ✅ Validation
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

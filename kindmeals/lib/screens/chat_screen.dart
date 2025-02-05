import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String recipientName; // ✅ Accept recipient name

  const ChatScreen({super.key, required this.recipientName}); // ✅ Constructor to receive donor name

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Chat with $recipientName')), // ✅ Show correct name
      body: Column(
        children: [
          Expanded(child: ListView()), // Placeholder for chat messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // TODO: Implement chat backend
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

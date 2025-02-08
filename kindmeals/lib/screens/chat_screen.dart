import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: RecentChatsScreen(),
  ));
}

// Dummy data for recent chats
class RecentChat {
  final String recipientName;
  String lastMessage;
  String time;

  RecentChat({
    required this.recipientName,
    required this.lastMessage,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  final String recipientName;
  final Function(String) onMessageSent;

  const ChatScreen({super.key, required this.recipientName, required this.onMessageSent});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String message = messageController.text;
    setState(() {
      messages.add(message);
    });
    widget.onMessageSent(message); // Update the recent chat list with the new message
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.recipientName}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(messages[index], style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({super.key});

  @override
  _RecentChatsScreenState createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  final List<RecentChat> recentChats = [
    RecentChat(recipientName: 'Donor 1', lastMessage: 'Looking forward to your help.', time: '10:30 AM'),
    RecentChat(recipientName: 'Donor 2', lastMessage: 'I will deliver the food soon.', time: '9:15 AM'),
    RecentChat(recipientName: 'Donor 3', lastMessage: 'I have confirmed the donation.', time: 'Yesterday'),
  ];

  void _updateRecentChat(String recipientName, String message) {
    setState(() {
      // Check if the chat already exists
      bool chatExists = false;
      for (var chat in recentChats) {
        if (chat.recipientName == recipientName) {
          chat.lastMessage = message;
          chat.time = DateTime.now().toString();
          chatExists = true;
          break;
        }
      }

      // If not, add a new recent chat
      if (!chatExists) {
        recentChats.insert(0, RecentChat(recipientName: recipientName, lastMessage: message, time: DateTime.now().toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Chats'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: recentChats.length,
        itemBuilder: (context, index) {
          final chat = recentChats[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    recipientName: chat.recipientName,
                    onMessageSent: (message) {
                      _updateRecentChat(chat.recipientName, message);
                    },
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.green, // First letter of recipient name
              foregroundColor: Colors.white,
              child: Text(chat.recipientName[0]),
            ),
            title: Text(chat.recipientName),
            subtitle: Text(chat.lastMessage),
            trailing: Text(chat.time),
          );
        },
      ),
    );
  }
}

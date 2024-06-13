// lib/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String userId;

  const ChatListScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: ListView(
        children: [
          // Örnek satıcı listesi, buraya den@gmail.com adresini ekliyoruz
          ListTile(
            title: const Text('Seller den@gmail.com'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(userId: userId, receiverId: 'den@gmail.com'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

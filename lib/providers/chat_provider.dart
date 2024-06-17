// lib/providers/chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatNotifier() : super([]) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    final messagesSnapshot = await _firestore.collection('chat_messages').orderBy('timestamp').get();
    state = messagesSnapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList();
  }

  Future<void> sendMessage(ChatMessage message) async {
    await _firestore.collection('chat_messages').add(message.toJson());
    state = [...state, message];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

class AppMessage extends Equatable {
  final String id;
  final String authorId;
  final String text;
  final int createdAt; // Milliseconds since epoch
  final bool isEmojiOnly; // Optional: to handle emoji-specific styling

  const AppMessage({
    required this.id,
    required this.authorId,
    required this.text,
    required this.createdAt,
    this.isEmojiOnly = false,
  });

  @override
  List<Object?> get props => [id, authorId, text, createdAt, isEmojiOnly];

  // Convert to flutter_chat_types TextMessage
  chat_types.TextMessage toChatUIMessage() {
    return chat_types.TextMessage(
      author: chat_types.User(id: authorId),
      id: id,
      text: text,
      createdAt: createdAt,
    );
  }

  // Factory to create from Firestore document
  factory AppMessage.fromFirestore(Map<String, dynamic> data, String id) {
    final text = data['text'] as String? ?? '';
    return AppMessage(
      id: id,
      authorId: data['userId'] as String? ?? '',
      text: text,
      createdAt: (data['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
      isEmojiOnly: text.contains(RegExp(r'^[\p{Emoji}\s]+$', unicode: true)),
    );
  }
}
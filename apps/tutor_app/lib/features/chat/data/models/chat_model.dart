// ignore_for_file: unnecessary_this

import 'package:equatable/equatable.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;

class ChatModel extends Equatable {
  final String chatId;
  final String userId;
  final String tutorId; // Or recipientId, depending on your use case
  final List<chat_ui.Message> messages;

  const ChatModel({
    required this.chatId,
    required this.userId,
    required this.tutorId,
    required this.messages,
  });

  @override
  List<Object?> get props => [chatId, userId, tutorId, messages];

  ChatModel copyWith({
    String? chatId,
    String? userId,
    String? courseId,
    List<chat_ui.Message>? messages,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      tutorId: courseId ?? this.tutorId,
      messages: messages ?? this.messages,
    );
  }
}
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import  'package:user_app/features/chat/data/models/messgae_class.dart';

abstract class ChatScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatScreenState {}

class ChatLoading extends ChatScreenState {}

class ChatLoaded extends ChatScreenState {
  final List<AppMessage> messages;
  final String chatId;
  final bool isTyping;
  final chat_types.User? mentor;

  ChatLoaded({
    required this.messages,
    required this.chatId,
    this.isTyping = false,
    this.mentor,
  });

  List<chat_types.Message> get chatUIMessages => messages.map((m) => m.toChatUIMessage()).toList();

  @override
  List<Object?> get props => [messages, chatId, isTyping, mentor];
}

class ChatError extends ChatScreenState {
  final String message;

  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
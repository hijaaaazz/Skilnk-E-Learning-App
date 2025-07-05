
// lib/features/chat/presentation/bloc/chat_bloc/chat_event.dart
import 'package:equatable/equatable.dart';
import  'package:user_app/features/chat/domain/usecaase/send_message_usecase.dart';
import  'package:user_app/features/chat/data/models/messgae_class.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeChatEvent extends ChatEvent {
  final String userId;
  final String tutorId;

  InitializeChatEvent({required this.userId, required this.tutorId});

  @override
  List<Object?> get props => [userId, tutorId];
}

class LoadChatEvent extends ChatEvent {
  final String chatId;

  LoadChatEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final SendMessageParams params;

  SendMessageEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class MessagesUpdatedEvent extends ChatEvent {
  final List<AppMessage> messages;

  MessagesUpdatedEvent(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatErrorEvent extends ChatEvent {
  final String error;

  ChatErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}
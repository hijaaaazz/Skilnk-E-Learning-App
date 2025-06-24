import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';

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
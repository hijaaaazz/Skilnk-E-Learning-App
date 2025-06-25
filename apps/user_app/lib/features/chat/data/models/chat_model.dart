import 'package:equatable/equatable.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class TutorChat extends Equatable {
  final String chatId;
  final MentorEntity user;
  final String? lastMessage; // Or recipientId, depending on your use case
  final DateTime? lastmessagedAt;

  const TutorChat({
    required this.chatId,
    required this.user,
    required this.lastMessage,
    required this.lastmessagedAt,
  });

  @override
  List<Object?> get props => [chatId, user, lastMessage, lastmessagedAt];

  TutorChat copyWith({
    String? chatId,
    MentorEntity? user,
    String? lastMessage,
    DateTime? lastMessagedAt,
  }) {
    return TutorChat(
      chatId: chatId ?? this.chatId,
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      lastmessagedAt: lastmessagedAt ?? this.lastmessagedAt,
    );
  }
}
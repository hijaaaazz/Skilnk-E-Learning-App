
import 'package:tutor_app/features/chat/data/models/student_model.dart';

class StudentChat {
  final String chatId;
  final StudentEntity user;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  StudentChat({
    required this.chatId,
    required this.user,
    this.lastMessage,
    this.lastMessageAt,
  });

  @override
  String toString() => 'TutorChat(chatId: $chatId, user: ${user.name})';
}
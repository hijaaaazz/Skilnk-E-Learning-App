
// lib/features/chat/domain/repo/chat_repo.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/data/models/stuent_chat_model.dart';
import 'package:tutor_app/features/chat/domain/usecaase/check_chat_exist.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';

abstract class ChatRepository {
  Stream<Either<String, List<AppMessage>>> loadMessages(String chatId);
  Future<Either<String, Unit>> sendMessage(SendMessageParams params);
  Future<Either<String, String>> checkChatExists(CheckChatParams params);
  Stream<Either<String, List<StudentChat>>> loadChatList(String tutorId);
}

import 'package:dartz/dartz.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/domain/usecaase/check_chat_exist.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';

abstract class ChatRepository {
  Future<Either<String, List<StudentChat>>> loadChatList(String chatId);
   Future<Either<String, List<AppMessage>>> loadMessages(String chatId);
  Future<Either<String, Unit>> sendMessage(SendMessageParams params);
  Future<Either<String, String>> checkChatExists(CheckChatParams params);
}

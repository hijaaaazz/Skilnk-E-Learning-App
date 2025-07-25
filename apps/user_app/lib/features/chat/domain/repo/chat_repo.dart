// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import  'package:user_app/features/chat/data/models/chat_model.dart';
import  'package:user_app/features/chat/data/models/messgae_class.dart';
import  'package:user_app/features/chat/domain/repo/chat_repo.dart';
import  'package:user_app/features/chat/domain/usecaase/check_chat_exist.dart';
import  'package:user_app/features/chat/domain/usecaase/send_message_usecase.dart';

abstract class ChatRepository {
  Stream<Either<String, List<AppMessage>>> loadMessages(String chatId);
  Future<Either<String, Unit>> sendMessage(SendMessageParams params);
  Future<Either<String, String>> checkChatExists(CheckChatParams params);
  Stream<Either<String, List<TutorChat>>> loadChatList(String chatId);
}
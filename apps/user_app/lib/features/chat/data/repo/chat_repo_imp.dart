
// lib/features/chat/data/repo/chat_repo_imp.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import  'package:user_app/features/chat/data/models/chat_model.dart';
import  'package:user_app/features/chat/data/models/messgae_class.dart';
import  'package:user_app/features/chat/data/service/firebase_chat.dart';
import  'package:user_app/features/chat/domain/repo/chat_repo.dart';
import  'package:user_app/features/chat/domain/usecaase/check_chat_exist.dart';
import  'package:user_app/features/chat/domain/usecaase/send_message_usecase.dart';
import  'package:user_app/service_locator.dart';
import 'dart:developer';

class ChatRepoImp implements ChatRepository {
  final ChatFirebaseService _firebaseService =
      serviceLocator<ChatFirebaseService>();

  @override
  Stream<Either<String, List<AppMessage>>> loadMessages(String chatId) async* {
    try {
      await for (final messages in _firebaseService.loadMessages(chatId)) {
        log('Loaded ${messages.length} messages for chatId: $chatId');
        yield Right(messages);
      }
    } catch (e) {
      log('Error loading messages: $e');
      yield Left('Failed to load messages: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Unit>> sendMessage(SendMessageParams params) async {
    try {
      await _firebaseService.sendMessage(
        userId: params.userId,
        courseId: params.courseId,
        text: params.text,
      );
      log('Message sent to chatId: ${params.chatId}');
      return const Right(unit);
    } catch (e) {
      log('Error sending message: $e');
      return Left('Failed to send message: $e');
    }
  }

  @override
  Future<Either<String, String>> checkChatExists(CheckChatParams params) async {
    try {
      final chatId = await _firebaseService.checkChatExists(
        userId: params.userId,
        tutorId: params.courseId,
      );
      log('Chat exists or created with chatId: $chatId');
      return Right(chatId);
    } catch (e) {
      log('Error checking chat existence: $e');
      return Left('Failed to check chat existence: $e');
    }
  }

 @override
Stream<Either<String, List<TutorChat>>> loadChatList(String chatId) async* {
  try {
    yield* _firebaseService.loadChatList(userId: chatId);
  } catch (e, stack) {
    log('[loadChatList Repo] Error: $e', stackTrace: stack);
    yield Left('Failed to load chat list: $e');
  }
}



}

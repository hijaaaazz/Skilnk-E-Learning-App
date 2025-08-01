// lib/features/chat/domain/usecaase/send_message_usecase.dart
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/chat/domain/repo/chat_repo.dart';
import  'package:user_app/service_locator.dart';
import 'dart:developer';

class SendMessageUseCase implements Usecase<Either<String, Unit>, SendMessageParams> {
  @override
  Future<Either<String, Unit>> call({required SendMessageParams params}) async {
    log('Sending message to chatId: ${params.chatId}');
    return serviceLocator<ChatRepository>().sendMessage(params);
  }
}

class SendMessageParams {
  final String chatId;
  final String userId;
  final String courseId;
  final String text;

  SendMessageParams({
    required this.chatId,
    required this.userId,
    required this.courseId,
    required this.text,
  });
}
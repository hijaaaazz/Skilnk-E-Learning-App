// lib/features/chat/domain/usecaase/check_chat_exist.dart
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/chat/domain/repo/chat_repo.dart';
import 'package:user_app/service_locator.dart';
import 'dart:developer';

class CheckChatExistsUseCase implements Usecase<Either<String, String>, CheckChatParams> {
  @override
  Future<Either<String, String>> call({required CheckChatParams params}) async {
    log('Checking if chat exists for userId: ${params.userId}, courseId: ${params.courseId}');
    return serviceLocator<ChatRepository>().checkChatExists(params);
  }
}

class CheckChatParams {
  final String userId;
  final String courseId;

  CheckChatParams({
    required this.userId,
    required this.courseId,
  });
}
// lib/features/chat/domain/usecaase/loadchat_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/chat/data/models/messgae_class.dart';
import 'package:user_app/features/chat/domain/repo/chat_repo.dart';
import 'package:user_app/service_locator.dart';
import 'dart:developer';

class LoadChatUseCase implements Usecase<Either<String, List<AppMessage>>, String> {
  @override
  Future<Either<String, List<AppMessage>>> call({required String params}) async {
    log('Loading messages for chatId: $params');
    return serviceLocator<ChatRepository>().loadMessages(params);
  }
}
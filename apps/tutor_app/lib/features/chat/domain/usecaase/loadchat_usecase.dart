// lib/features/chat/domain/usecaase/loadchat_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';

import 'dart:developer';

import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/domain/repo/chat_repo.dart';
import 'package:tutor_app/service_locator.dart';

class LoadChatUseCase implements Usecase<Either<String, List<AppMessage>>, String> {
  @override
  Future<Either<String, List<AppMessage>>> call({required String params}) async {
    log('Loading messages for chatId: $params');
    return serviceLocator<ChatRepository>().loadMessages(params);
  }
}
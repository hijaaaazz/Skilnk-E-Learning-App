
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/domain/repo/chat_repo.dart';
import 'package:tutor_app/service_locator.dart';
import 'dart:developer';

class LoadChatUseCase implements StreamUsecase<Either<String, List<AppMessage>>, String> {
  @override
  Stream<Either<String, List<AppMessage>>> call({required String params}) {
    log('Loading messages for chatId: $params');
    return serviceLocator<ChatRepository>().loadMessages(params);
  }
}

// lib/features/chat/domain/usecases/load_chat_list.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/chat/data/models/stuent_chat_model.dart';
import 'package:tutor_app/features/chat/domain/repo/chat_repo.dart';
import 'package:tutor_app/service_locator.dart';
import 'dart:developer';

class LoadChatListUseCase implements StreamUsecase<Either<String, List<StudentChat>>, String> {
  @override
  Stream<Either<String, List<StudentChat>>> call({required String params}) {
    log('Loading chat list for tutorId: $params');
    return serviceLocator<ChatRepository>().loadChatList(params);
  }
}

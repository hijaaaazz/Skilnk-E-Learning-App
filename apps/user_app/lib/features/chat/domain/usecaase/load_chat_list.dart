// lib/features/chat/domain/usecaase/loadchat_usecase.dart
// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/chat/data/models/chat_model.dart';
import  'package:user_app/features/chat/domain/repo/chat_repo.dart';

import 'dart:developer';

import  'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import  'package:user_app/service_locator.dart';


class LoadChatListUseCase implements StreamUsecase<Either<String, List<TutorChat>>, String> {
  @override
  Stream<Either<String, List<TutorChat>>> call({required String params}) {
    log('Loading messages for chatId: $params');
    return serviceLocator<ChatRepository>().loadChatList(params);
  }
}

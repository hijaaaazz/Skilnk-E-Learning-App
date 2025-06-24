// lib/features/chat/domain/usecaase/loadchat_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';

import 'dart:developer';

import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/domain/repo/chat_repo.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import 'package:tutor_app/service_locator.dart';

class LoadChatListUseCase implements Usecase<Either<String, List<StudentChat>>, String> {
  @override
  Future<Either<String, List<StudentChat>>> call({required String params}) async {
    log('Loading messages for chatId: $params');
    return serviceLocator<ChatRepository>().loadChatList(params);
  }
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:tutor_app/features/chat/data/models/messgae_class.dart';
import 'package:tutor_app/features/chat/domain/usecaase/check_chat_exist.dart';
import 'package:tutor_app/features/chat/domain/usecaase/loadchat_usecase.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';

import 'dart:developer';

import 'package:tutor_app/features/chat/presentation/chat/bloc/chat_event.dart';
import 'package:tutor_app/features/chat/presentation/chat/bloc/chat_state.dart';
import 'package:tutor_app/service_locator.dart';

class ChatBloc extends Bloc<ChatEvent, ChatScreenState> {
  final chat_types.User user;
  final chat_types.User mentor;

  ChatBloc({
    required this.user,
    required this.mentor,
  }) : super(ChatInitial()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onInitializeChat(InitializeChatEvent event, Emitter<ChatScreenState> emit) async {
    emit(ChatLoading());
    final result = await serviceLocator<CheckChatExistsUseCase>().call(
      params: CheckChatParams(userId: event.userId, courseId: event.tutorId),
    );
    await result.fold(
      (error) async {
        log('Error initializing chat: $error');
        emit(ChatError(error));
      },
      (chatId) async {
        add(LoadChatEvent(chatId: chatId));
      },
    );
  }

  Future<void> _onLoadChat(LoadChatEvent event, Emitter<ChatScreenState> emit) async {
    emit(ChatLoading());
    final result = await serviceLocator<LoadChatUseCase>().call(params: event.chatId);
    result.fold(
      (error) {
        log('Error loading chat: $error');
        emit(ChatError(error));
      },
      (messages) {
        emit(ChatLoaded(
          messages: messages,
          chatId: event.chatId,
          isTyping: false, // Update with typing logic
          mentor: mentor,
        ));
      },
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatScreenState> emit) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final result = await serviceLocator<SendMessageUseCase>().call(params: event.params);
      result.fold(
        (error) {
          log('Error sending message: $error');
          emit(ChatError(error));
        },
        (_) {
          final newMessage = AppMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            authorId: event.params.userId,
            text: event.params.text,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            isEmojiOnly: event.params.text.contains(RegExp(r'^[\p{Emoji}\s]+$', unicode: true)),
          );
          emit(ChatLoaded(
            messages: [newMessage, ...currentState.messages],
            chatId: currentState.chatId,
            isTyping: false,
            mentor: mentor,
          ));
          add(LoadChatEvent(chatId: event.params.chatId));
        },
      );
    }
  }
}
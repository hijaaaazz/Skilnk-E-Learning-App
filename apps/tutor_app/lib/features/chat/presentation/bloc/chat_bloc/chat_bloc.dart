
// lib/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:tutor_app/features/chat/domain/usecaase/check_chat_exist.dart';
import 'package:tutor_app/features/chat/domain/usecaase/loadchat_usecase.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:tutor_app/service_locator.dart';
import 'dart:developer';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatScreenState> {
  final chat_types.User user;
  final chat_types.User mentor;
  StreamSubscription? _messagesSubscription;

  ChatBloc({
    required this.user,
    required this.mentor,
  }) : super(ChatInitial()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
    on<MessagesUpdatedEvent>(_onMessagesUpdated);
    on<ChatErrorEvent>(_onChatError);
  }

  Future<void> _onInitializeChat(InitializeChatEvent event, Emitter<ChatScreenState> emit) async {
    emit(ChatLoading());
    final result = await serviceLocator<CheckChatExistsUseCase>().call(
      params: CheckChatParams(userId: event.userId, tutorId: event.tutorId),
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
    final result = serviceLocator<LoadChatUseCase>().call(params: event.chatId);
    _messagesSubscription?.cancel();
    _messagesSubscription = result.listen((either) {
      either.fold(
        (error) => add(ChatErrorEvent(error)),
        (messages) => add(MessagesUpdatedEvent(messages)),
      );
    });
  }

 Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatScreenState> emit) async {
  log('[SEND MESSAGE] chatId: "${event.params.chatId}", userId: "${event.params.userId}", courseId: "${event.params.courseId}"');

  if (event.params.chatId.isEmpty || event.params.userId.isEmpty || event.params.courseId.isEmpty) {
    log('[SEND MESSAGE] ERROR: One or more required fields are empty');
    emit(ChatError('Unable to send message. Required information is missing.'));
    return;
  }

  final currentState = state;
  if (currentState is ChatLoaded) {
    final result = await serviceLocator<SendMessageUseCase>().call(params: event.params);
    result.fold(
      (error) {
        log('Error sending message: $error');
        emit(ChatError(error));
      },
      (_) {
        // Message will be updated via stream
      },
    );
  }
}


  Future<void> _onMessagesUpdated(MessagesUpdatedEvent event, Emitter<ChatScreenState> emit) async {
    final currentState = state;
    String chatId = currentState is ChatLoaded ? currentState.chatId : '';
    emit(ChatLoaded(
      messages: event.messages,
      chatId: chatId,
      isTyping: false,
      mentor: mentor,
    ));
  }

  Future<void> _onChatError(ChatErrorEvent event, Emitter<ChatScreenState> emit) async {
    log('Error in stream: ${event.error}');
    emit(ChatError(event.error));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
// lib/features/chat/presentation/bloc/tutor_chat_list/tutor_chat_list_bloc.dart
import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:tutor_app/features/chat/domain/usecaase/load_chat_list.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import 'package:tutor_app/service_locator.dart';


class TutorChatListBloc extends Bloc<TutorChatListEvent, TutorChatListState> {
  StreamSubscription? _chatListSubscription;

  TutorChatListBloc() : super(TutorChatListInitial()) {
    on<LoadTutorChatsEvent>(_onLoadTutorChats);
    on<TutorChatsUpdatedEvent>(_onTutorChatsUpdated);
    on<TutorChatListErrorEvent>(_onTutorChatListError);
  }

  final loadTutorChatsUseCase = serviceLocator<LoadChatListUseCase>();

  Future<void> _onLoadTutorChats(LoadTutorChatsEvent event, Emitter<TutorChatListState> emit) async {
    emit(TutorChatListLoading());
    final result = loadTutorChatsUseCase.call(params: event.tutorId);
    _chatListSubscription?.cancel();
    _chatListSubscription = result.listen((either) {
      either.fold(
        (error) => add(TutorChatListErrorEvent(error)),
        (chats) => add(TutorChatsUpdatedEvent(chats)),
      );
    });
  }

  Future<void> _onTutorChatsUpdated(TutorChatsUpdatedEvent event, Emitter<TutorChatListState> emit) async {
    log('Updated tutor chat list with ${event.chats.length} chats');
    emit(TutorChatListLoaded(event.chats));
  }

  Future<void> _onTutorChatListError(TutorChatListErrorEvent event, Emitter<TutorChatListState> emit) async {
    log('Error in tutor chat list stream: ${event.error}');
    emit(TutorChatListError(event.error));
  }

  @override
  Future<void> close() {
    _chatListSubscription?.cancel();
    return super.close();
  }
}

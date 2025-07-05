import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import  'package:user_app/features/chat/data/models/chat_model.dart';
import  'package:user_app/features/chat/domain/usecaase/load_chat_list.dart';
import  'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import  'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import  'package:user_app/service_locator.dart';


class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {

  ChatListBloc() : super(ChatListInitial()) {
    on<LoadChatsEvent>(_onLoadTutorChats);
  }
  final loadTutorChatsUseCase = serviceLocator<LoadChatListUseCase>();

  
Future<void> _onLoadTutorChats(LoadChatsEvent event, Emitter<ChatListState> emit) async {
  emit(ChatListLoading());

  await emit.forEach<Either<String, List<TutorChat>>>(
   loadTutorChatsUseCase.call(params: event.tutorId),
    onData: (result) => result.fold(
      (error) => ChatListError(error),
      (chats) => ChatListLoaded(chats),
    ),
    onError: (error, stackTrace) {
      return ChatListError('Unexpected error: $error');
    },
  );
}
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/chat/domain/usecaase/load_chat_list.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import 'package:tutor_app/service_locator.dart';


class TutorChatListBloc extends Bloc<TutorChatListEvent, TutorChatListState> {

  TutorChatListBloc() : super(TutorChatListInitial()) {
    on<LoadTutorChatsEvent>(_onLoadTutorChats);
  }
  final loadTutorChatsUseCase = serviceLocator<LoadChatListUseCase>();

  Future<void> _onLoadTutorChats(LoadTutorChatsEvent event, Emitter<TutorChatListState> emit) async {
    emit(TutorChatListLoading());
    final result = await loadTutorChatsUseCase.call(params: event.tutorId);
    result.fold(
      (error) => emit(TutorChatListError(error)),
      (chats) => emit(TutorChatListLoaded(chats)),
    );
  }
}
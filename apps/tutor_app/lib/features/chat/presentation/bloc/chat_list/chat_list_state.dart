// lib/features/chat/presentation/tutor/bloc/tutor_chat_list_state.dart


import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/chat/data/models/stuent_chat_model.dart';

abstract class TutorChatListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TutorChatListInitial extends TutorChatListState {}

class TutorChatListLoading extends TutorChatListState {}

class TutorChatListLoaded extends TutorChatListState {
  final List<StudentChat> chats;

  TutorChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class TutorChatListError extends TutorChatListState {
  final String message;

  TutorChatListError(this.message);

  @override
  List<Object?> get props => [message];
}

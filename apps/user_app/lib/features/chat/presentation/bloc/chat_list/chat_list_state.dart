// lib/features/chat/presentation//bloc/_chat_list_state.dart


import 'package:equatable/equatable.dart';
import 'package:user_app/features/chat/data/models/chat_model.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class ChatListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<TutorChat> chats;

  ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatListError extends ChatListState {
  final String message;

  ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}

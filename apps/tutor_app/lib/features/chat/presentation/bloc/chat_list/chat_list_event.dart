
// lib/features/chat/presentation/bloc/tutor_chat_list/tutor_chat_list_event.dart
import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/chat/data/models/stuent_chat_model.dart';

abstract class TutorChatListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTutorChatsEvent extends TutorChatListEvent {
  final String tutorId;

  LoadTutorChatsEvent({required this.tutorId});

  @override
  List<Object?> get props => [tutorId];
}

class TutorChatsUpdatedEvent extends TutorChatListEvent {
  final List<StudentChat> chats;

  TutorChatsUpdatedEvent(this.chats);

  @override
  List<Object?> get props => [chats];
}

class TutorChatListErrorEvent extends TutorChatListEvent {
  final String error;

  TutorChatListErrorEvent(this.error);

  @override
  List<Object?> get props => [error];
}

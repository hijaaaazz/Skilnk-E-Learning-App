// lib/features/chat/presentation/tutor/bloc/tutor_chat_list_event.dart

import 'package:equatable/equatable.dart';

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

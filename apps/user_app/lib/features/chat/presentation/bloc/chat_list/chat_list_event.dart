// lib/features/chat/presentation/tutor/bloc/tutor_chat_list_event.dart

import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatListEvent {
  final String tutorId;

  LoadChatsEvent({required this.tutorId});

  @override
  List<Object?> get props => [tutorId];
}

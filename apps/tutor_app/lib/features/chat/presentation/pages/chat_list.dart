import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/chat/domain/usecaase/load_chat_list.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';
import 'package:tutor_app/service_locator.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  Widget build(BuildContext context) {
    final tutorId = context.read<AuthBloc>().state.user?.tutorId ?? '';
    if (tutorId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Tutor not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => TutorChatListBloc()..add(LoadTutorChatsEvent(tutorId: context.read<AuthBloc>().state.user?.tutorId ?? "")),
      child: const TutorChatListView(),
    );
  }
}

class TutorChatListView extends StatelessWidget {
  const TutorChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
      ),
      body: BlocBuilder<TutorChatListBloc, TutorChatListState>(
        builder: (context, state) {
          if (state is TutorChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TutorChatListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<TutorChatListBloc>().add(
                          LoadTutorChatsEvent(
                            tutorId: context.read<AuthBloc>().state.user?.tutorId ?? '',
                          ),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TutorChatListLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text('No chats available'));
            }
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: chat.user.imageUrl.isNotEmpty ? NetworkImage(chat.user.imageUrl) : null,
                    backgroundColor: Colors.grey[300],
                    child: chat.user.imageUrl.isEmpty
                        ? Text(chat.user.name.isNotEmpty ? chat.user.name[0] : 'U')
                        : null,
                  ),
                  title: Text(chat.user.name.isNotEmpty ? chat.user.name : 'User ${chat.user.id}'),
                  subtitle: Text(
                    chat.lastMessage ?? 'No messages yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    chat.lastMessageAt != null
                        ? _formatDateTime(chat.lastMessageAt!)
                        : '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () => context.pushNamed(
                    AppRouteConstants.chatscreen,
                    extra: chat.user
                    
                    
                 //   extra: chat.user,
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

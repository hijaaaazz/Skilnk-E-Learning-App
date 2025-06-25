import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorId = context.read<AuthStatusCubit>().state.user?.userId ?? '';
    if (tutorId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Tutor not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => ChatListBloc()..add(LoadChatsEvent(tutorId: tutorId)),
      child: const TutorChatListView(),
    );
  }
}

class TutorChatListView extends StatelessWidget {
  const TutorChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Chats')),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final tutorId = context.read<AuthStatusCubit>().state.user?.userId ?? '';
                      context.read<ChatListBloc>().add(LoadChatsEvent(tutorId: tutorId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ChatListLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text('No chats available'));
            }

            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: chat.user.imageUrl.isNotEmpty
                        ? NetworkImage(chat.user.imageUrl)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: chat.user.imageUrl.isEmpty
                        ? Text(chat.user.name.isNotEmpty ? chat.user.name[0].toUpperCase() : 'U')
                        : null,
                  ),
                  title: Text(chat.user.name),
                  subtitle: Text(
                    chat.lastMessage ?? 'No messages yet',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _formatDateTime(chat.lastmessagedAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    context.pushNamed(AppRouteConstants.chatPaage, extra: chat.user);
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    if (now.difference(dateTime).inDays == 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

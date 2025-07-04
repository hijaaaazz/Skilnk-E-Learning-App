import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:user_app/features/chat/presentation/widgets/custom_message.dart';
import 'package:user_app/features/chat/presentation/widgets/mentor_avatar.dart';
import 'package:user_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class ChatPage extends StatelessWidget {
  final MentorEntity mentor;

  const ChatPage({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthStatusCubit>().state.user?.userId ?? '';
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('User not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => ChatBloc(
        user: chat_types.User(id: userId),
        mentor: chat_types.User(id: mentor.id),
      )..add(InitializeChatEvent(userId: userId, tutorId: mentor.id)),
      child: ChatView(mentor: mentor),
    );
  }
}

class ChatView extends StatelessWidget {
  final MentorEntity mentor;

  const ChatView({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: ModernMentorHeader(mentor: mentor),
      body: BlocBuilder<ChatBloc, ChatScreenState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
                strokeWidth: 3,
              ),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => chatBloc.add(
                      InitializeChatEvent(
                        userId: context
                                .read<AuthStatusCubit>()
                                .state
                                .user
                                ?.userId ??
                            '',
                        tutorId: mentor.id,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          List<chat_types.Message> messages = [];
          bool isTyping = false;
          String chatId = '';

          if (state is ChatLoaded) {
            messages = state.chatUIMessages;
            isTyping = state.isTyping;
            chatId = state.chatId;
          }

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ModernChatWidget(
                      messages: messages,
                      user: chatBloc.user,
                      onSendPressed: (partialText) {
                        if (partialText.text.isNotEmpty) {
                          chatBloc.add(
                            SendMessageEvent(
                              params: SendMessageParams(
                                chatId: chatId,
                                userId: chatBloc.user.id,
                                courseId: mentor.id,
                                text: partialText.text,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    if (isTyping)
                      const Positioned(
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: ModernTypingIndicator(),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ModernChatWidget extends StatelessWidget {
  final List<chat_types.Message> messages;
  final chat_types.User user;
  final Function(chat_types.PartialText) onSendPressed;

  const ModernChatWidget({
    super.key,
    required this.messages,
    required this.user,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildMessagesList(),
        ),
        _buildModernInputArea(context),
      ],
    );
  }

  Widget _buildMessagesList() {
    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    // Sort messages by timestamp (oldest first)
    final sortedMessages = List<chat_types.Message>.from(messages)
      ..sort((a, b) => (a.createdAt ?? 0).compareTo(b.createdAt ?? 0));

    // Group messages by date
    final groupedMessages = _groupMessagesByDate(sortedMessages);
    
    // Build the list items (messages + date separators)
    final listItems = <Widget>[];
    
    for (int i = 0; i < groupedMessages.length; i++) {
      final group = groupedMessages[i];
      
      // Add date separator
      listItems.add(_buildModernDateSeparator(group['date'] as String));
      
      // Add messages for this date
      final groupMessages = group['messages'] as List<chat_types.Message>;
      for (final message in groupMessages) {
        listItems.add(
          ModernMessageWidget(
            message: message,
            isCurrentUser: message.author.id == user.id,
          ),
        );
      }
    }

    return ListView.builder(
      reverse: true, // Show newest messages at bottom
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: listItems.length,
      itemBuilder: (context, index) {
        // Reverse the index to show newest at bottom
        final reversedIndex = listItems.length - 1 - index;
        return listItems[reversedIndex];
      },
    );
  }

  List<Map<String, dynamic>> _groupMessagesByDate(List<chat_types.Message> sortedMessages) {
    final Map<String, List<chat_types.Message>> grouped = {};

    for (var message in sortedMessages) {
      final date = DateTime.fromMillisecondsSinceEpoch(message.createdAt ?? 0);
      final dateKey = _formatDateKey(date);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(message);
    }

    // Convert to list and sort by date
    final groupedList = grouped.entries.map((entry) => {
      'date': entry.key,
      'messages': entry.value,
      'timestamp': _getDateTimestamp(entry.key),
    }).toList();

    groupedList.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));

    return groupedList;
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(messageDate).inDays < 7) {
      // Show day name for this week
      const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return days[date.weekday - 1];
    } else {
      // Show date for older messages
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  int _getDateTimestamp(String dateKey) {
    final now = DateTime.now();
    
    if (dateKey == 'Today') {
      return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    } else if (dateKey == 'Yesterday') {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day).millisecondsSinceEpoch;
    } else if (['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].contains(dateKey)) {
      // For day names, approximate timestamp (this week)
      final today = DateTime(now.year, now.month, now.day);
      return today.subtract(Duration(days: 7)).millisecondsSinceEpoch;
    } else {
      // Parse full date format "DD MMM YYYY"
      try {
        final parts = dateKey.split(' ');
        if (parts.length >= 3) {
          final day = int.parse(parts[0]);
          final month = _getMonthNumber(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day).millisecondsSinceEpoch;
        }
      } catch (e) {
        // Fallback
      }
      return 0;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  int _getMonthNumber(String monthName) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[monthName] ?? 1;
  }

  Widget _buildModernDateSeparator(String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInputArea(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            
            const SizedBox(width: 12),
            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Send button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B35),
                    Color(0xFFFF8E53),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    onSendPressed(chat_types.PartialText(text: controller.text));
                    controller.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
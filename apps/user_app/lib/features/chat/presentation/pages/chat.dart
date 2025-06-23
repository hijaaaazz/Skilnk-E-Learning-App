import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:user_app/features/chat/presentation/chat/bloc/chat_bloc.dart';
import 'package:user_app/features/chat/presentation/chat/bloc/chat_event.dart';
import 'package:user_app/features/chat/presentation/chat/bloc/chat_state.dart';
import 'package:user_app/features/chat/presentation/widgets/mentor_avatar.dart';
import 'package:user_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/service_locator.dart';

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
      appBar: MentorHeader(mentor: mentor),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<ChatBloc, ChatScreenState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => chatBloc.add(InitializeChatEvent(
                      userId: context.read<AuthStatusCubit>().state.user?.userId ?? '',
                      tutorId: mentor.id,
                    )),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          List<chat_types.Message> messages = [];
          bool isTyping = false;

          if (state is ChatLoaded) {
            messages = state.chatUIMessages;
            isTyping = state.isTyping;
          }

          return Column(
            children: [
              
              Expanded(
                child: Stack(
                  children: [
                    chat_ui.Chat(
                      theme: chat_ui.DefaultChatTheme(
                        backgroundColor: Colors.grey[50]!,
                        primaryColor: Colors.blue,
                        secondaryColor: Colors.grey[100]!,
                        inputBackgroundColor: Colors.white,
                        inputTextColor: Colors.black87,
                        inputBorderRadius: BorderRadius.circular(24),
                        messageBorderRadius: 20,
                        messageInsetsHorizontal: 16,
                        messageInsetsVertical: 8,
                        receivedMessageBodyTextStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        sentMessageBodyTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        inputTextStyle: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                        inputPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        sendButtonIcon: const Icon(
                          Icons.send_rounded,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      messages: messages,
                      onSendPressed: (partialText) {
                        if (partialText.text.isNotEmpty) {
                          chatBloc.add(SendMessageEvent(
                            params: SendMessageParams(
                              chatId: state is ChatLoaded ? state.chatId : '',
                              userId: chatBloc.user.id,
                              courseId: mentor.id,
                              text: partialText.text,
                            ),
                          ));
                        }
                      },
                      user: chatBloc.user,
                      showUserAvatars: false,
                      showUserNames: false,
                      emojiEnlargementBehavior: chat_ui.EmojiEnlargementBehavior.multi,
                      hideBackgroundOnEmojiMessages: true,
                      textMessageOptions: const chat_ui.TextMessageOptions(
                        isTextSelectable: true,
                      ),
                      usePreviewData: false,
                    ),
                    if (isTyping)
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AppTypingIndicator(),
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

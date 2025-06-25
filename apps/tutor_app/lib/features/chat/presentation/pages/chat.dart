import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/chat/data/models/student_model.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:tutor_app/features/chat/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:tutor_app/features/chat/presentation/widgets/mentor_avatar.dart';
import 'package:tutor_app/features/chat/presentation/widgets/typing_indicator.dart';

class ChatPage extends StatelessWidget {
  final StudentEntity student;

  const ChatPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.tutorId ?? '';
    if (userId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('User not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => ChatBloc(
        user: chat_types.User(id: userId),
        mentor: chat_types.User(id: student.id),
      )..add(InitializeChatEvent(userId: userId, tutorId: student.id)),
      child: ChatView(student: student),
    );
  }
}

class ChatView extends StatelessWidget {
  final StudentEntity student;

  const ChatView({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();

    return Scaffold(
      appBar: StudentHeader(student: student),
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatBloc, ChatScreenState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
                strokeWidth: 2,
              ),
            );
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => chatBloc.add(InitializeChatEvent(
                      userId: context.read<AuthBloc>().state.user?.tutorId ?? '',
                      tutorId: student.id,
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }

          List<chat_types.Message> messages = [];
          bool isTyping = false;
          String chatId = "";

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
                    chat_ui.Chat(
                      theme: chat_ui.DefaultChatTheme(
                        backgroundColor: Colors.white,
                        primaryColor: Colors.black87,
                        secondaryColor: Colors.white,
                        inputBackgroundColor: Colors.white,
                        inputTextColor: Colors.black87,
                        inputBorderRadius: BorderRadius.circular(24),
                        messageBorderRadius: 20,
                        messageInsetsHorizontal: 16,
                        messageInsetsVertical: 12,
                        receivedMessageBodyTextStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                        sentMessageBodyTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                        inputTextStyle: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                        inputPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        inputMargin: const EdgeInsets.all(16),
                        sendButtonIcon: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        attachmentButtonIcon: Icon(
                          Icons.add,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                        deliveredIcon: Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        seenIcon: Icon(
                          Icons.done_all,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        inputContainerDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                      ),
                      messages: messages,
                      onSendPressed: (partialText) {
                        if (partialText.text.isNotEmpty) {
                          chatBloc.add(SendMessageEvent(
                            params: SendMessageParams(
                              chatId: "${chatBloc.user.id}_${student.id}",
                              userId: chatBloc.user.id,
                              courseId: student.id,
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
                      scrollPhysics: const BouncingScrollPhysics(),
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

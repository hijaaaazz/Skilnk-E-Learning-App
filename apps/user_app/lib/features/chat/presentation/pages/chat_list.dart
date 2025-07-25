// ignore_for_file: deprecated_member_use, duplicate_ignore, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';
import '../../../../core/routes/app_route_constants.dart';
import '../../../account/presentation/blocs/auth_cubit/auth_cubit.dart';
import '../bloc/chat_list/chat_list_bloc.dart';
import '../bloc/chat_list/chat_list_event.dart';
import '../bloc/chat_list/chat_list_state.dart';
import 'unauth_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tutorId = context.read<AuthStatusCubit>().state.user?.userId ?? '';
    if (tutorId.isEmpty) {
      return const UnAthScreen();
    }

    return BlocProvider(
      create: (_) => ChatListBloc()..add(LoadChatsEvent(tutorId: tutorId)),
      child: ChatListView(
        searchController: _searchController,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        searchQuery: _searchQuery,
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const ChatListView({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(
        title: "Messages",
        
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Simple Header (matching home page style)
            _buildMinimalHeader(context),
            
            // Content
            Expanded(
              child: BlocBuilder<ChatListBloc, ChatListState>(
                builder: (context, state) {
                  if (state is ChatListLoading) {
                    return _buildLoadingState();
                  }
                  if (state is ChatListError) {
                    return _buildErrorState(context, state.message);
                  }
                  if (state is ChatListLoaded) {
                    final filteredChats = state.chats.where((chat) {
                      return chat.user.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }).toList();

                    if (filteredChats.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildChatList(filteredChats);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (matching home page)
          
          const SizedBox(height: 8),
          const Text(
            "Stay connected with your mentors.\nExplore.",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          // Simple Search Bar
          _buildMinimalSearchBar(),
        ],
      ),
    );
  }

  Widget _buildMinimalSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            // ignore: duplicate_ignore
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: const TextStyle(
          color: Color(0xFF1A1A1A),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(
            // ignore: deprecated_member_use
            color: const Color(0xFF666666).withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            // ignore: deprecated_member_use
            color: const Color(0xFF666666).withOpacity(0.6),
            size: 20,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
                  child: Icon(
                    Icons.close,
                    // ignore: deprecated_member_use
                    color: const Color(0xFF666666).withOpacity(0.6),
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFFF6B35),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading conversations...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final tutorId = context
                        .read<AuthStatusCubit>()
                        .state
                        .user?.userId ??
                    '';
                context
                    .read<ChatListBloc>()
                    .add(LoadChatsEvent(tutorId: tutorId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.chat_bubble_outline,
                size: 50,
                color: const Color(0xFFFF6B35).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              searchQuery.isNotEmpty
                  ? 'No conversations found'
                  : 'No conversations yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try searching with different keywords'
                  : 'Start a conversation to see it here',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.isEmpty) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Handle start new conversation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Start New Chat',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(List<dynamic> chats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header (minimal style)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Chats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                '${chats.length} conversation${chats.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Chat List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return MinimalChatListTile(chat: chats[index]);
            },
          ),
        ),
      ],
    );
  }
}

class MinimalChatListTile extends StatelessWidget {
  final dynamic chat;

  const MinimalChatListTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(AppRouteConstants.chatPaage, extra: chat.user);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Simple Avatar
                _buildMinimalAvatar(),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _formatDateTime(chat.lastmessagedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat.lastMessage ?? 'No messages yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: chat.user.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                chat.user.imageUrl,
                fit: BoxFit.cover,
              ),
            )
          : Center(
              child: Text(
                chat.user.name.isNotEmpty
                    ? chat.user.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      final hour = dateTime.hour;
      final minute = dateTime.minute;
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final period = hour >= 12 ? 'PM' : 'AM';
      return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

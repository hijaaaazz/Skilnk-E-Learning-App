import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_event.dart';
import 'package:user_app/features/chat/presentation/bloc/chat_list/chat_list_state.dart';

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
      return const Scaffold(
        body: Center(child: Text('Tutor not authenticated')),
      );
    }

    return BlocProvider(
      create: (_) => ChatListBloc()..add(LoadChatsEvent(tutorId: tutorId)),
      child: ModernChatListView(
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

class ModernChatListView extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const ModernChatListView({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // Modern Sliver App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFFF8E53),
                      Color(0xFFFFB366),
                      Color(0xFFFFC97B),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stay connected',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            // Action Buttons
                           
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Modern Search Bar
                        _buildModernSearchBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Chat List Content
          SliverToBoxAdapter(
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
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      height: 52,
    
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
              size: 24,
            ),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Loading conversations...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch your messages',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final tutorId = context
                          .read<AuthStatusCubit>()
                          .state
                          .user
                          ?.userId ??
                      '';
                  context
                      .read<ChatListBloc>()
                      .add(LoadChatsEvent(tutorId: tutorId));
                },
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B35).withOpacity(0.1),
                  const Color(0xFFFF8E53).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              searchQuery.isNotEmpty
                  ? Icons.search_off_rounded
                  : Icons.chat_bubble_outline_rounded,
              size: 50,
              color: const Color(0xFFFF6B35).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            searchQuery.isNotEmpty
                ? 'No conversations found'
                : 'No conversations yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            searchQuery.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Start a conversation to see it here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle start new conversation
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Start New Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatList(List<dynamic> chats) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Chats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${chats.length} conversation${chats.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Chat List
          ...chats.map((chat) => ModernChatListTile(chat: chat)).toList(),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }
}

class ModernChatListTile extends StatelessWidget {
  final dynamic chat;

  const ModernChatListTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed(AppRouteConstants.chatPaage, extra: chat.user);
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Modern Avatar with Status
                _buildModernAvatar(),
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
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildTimeAndStatus(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage ?? 'No messages yet',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                height: 1.3,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                         
                        ],
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

  Widget _buildModernAvatar() {
    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF6B35),
                Color(0xFFFF8E53),
                Color(0xFFFFB366),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: chat.user.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        
      ],
    );
  }

  Widget _buildTimeAndStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatDateTime(chat.lastmessagedAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
       
      ],
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
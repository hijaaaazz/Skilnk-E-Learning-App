import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;

class ModernMessageWidget extends StatelessWidget {
  final chat_types.Message message;
  final bool isCurrentUser;

  const ModernMessageWidget({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    if (message is chat_types.TextMessage) {
      return _buildModernTextMessage(message as chat_types.TextMessage,context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildModernTextMessage(chat_types.TextMessage textMessage, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B35),
                    Color(0xFFFF8E53),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  textMessage.author.firstName?.substring(0, 1).toUpperCase() ?? 
                  textMessage.author.id.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isCurrentUser
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFFF6B35),
                          Color(0xFFFF8E53),
                        ],
                      )
                    : null,
                color: isCurrentUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isCurrentUser ? 20 : 6),
                  bottomRight: Radius.circular(isCurrentUser ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCurrentUser
                        ? const Color(0xFFFF6B35).withOpacity(0.2)
                        : Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    textMessage.text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : const Color(0xFF1A1A1A),
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(textMessage.createdAt),
                        style: TextStyle(
                          color: isCurrentUser
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[500],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  String _formatTime(int? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = date.hour;
    final minute = date.minute;
    
    // Convert to 12-hour format
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    
    return '${displayHour.toString()}:${minute.toString().padLeft(2, '0')} $period';
  }
}
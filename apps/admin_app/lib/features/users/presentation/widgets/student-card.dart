import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/common/widgets/app_text.dart';
import 'package:admin_app/common/widgets/dialog.dart';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/presentation/bloc/cubit/user_management_cubit.dart';

class UserCard extends StatefulWidget {
  final UserEntity user;

  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Basic Info ListTile
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: _buildProfileImage(),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.user.isBlocked ? Colors.grey : Colors.black,
                      decoration: widget.user.isBlocked ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadges(),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _buildStatusRow(),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Expanded Details
          if (isExpanded) _buildExpandedDetails(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.user.isBlocked ? Colors.red : 
                 widget.user.emailVerified ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: widget.user.image != null && widget.user.image!.isNotEmpty
            ? Image.network(
                widget.user.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildAvatarFallback();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              )
            : _buildAvatarFallback(),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: widget.user.isBlocked ? Colors.red : Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadges() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.user.isBlocked)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Blocked',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (widget.user.emailVerified && !widget.user.isBlocked) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Icon(
          widget.user.emailVerified ? Icons.email : Icons.email_outlined,
          size: 16,
          color: widget.user.emailVerified ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          widget.user.emailVerified ? 'Email Verified' : 'Email Not Verified',
          style: TextStyle(
            fontSize: 12,
            color: widget.user.emailVerified ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          widget.user.lastLogin != null ? Icons.access_time : Icons.access_time_outlined,
          size: 16,
          color: widget.user.lastLogin != null ? Colors.blue : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          widget.user.lastLogin != null 
              ? 'Active ${_getTimeAgo(widget.user.lastLogin!)}'
              : 'Never logged in',
          style: TextStyle(
            fontSize: 12,
            color: widget.user.lastLogin != null ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (widget.user.isBlocked) {
      return TextButton.icon(
        onPressed: () => _showUnblockDialog(),
        icon: const Icon(Icons.check_circle, size: 16, color: Colors.green),
        label: const Text('Unblock'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      );
    }

    return TextButton.icon(
      onPressed: () => _showBlockDialog(),
      icon: const Icon(Icons.block, size: 16, color: Colors.red),
      label: const Text('Block'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  Widget _buildExpandedDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),
          
          // Account Information
          _buildAccountInfo(),
          
          const SizedBox(height: 16),
          
          // Activity Information
          _buildActivityInfo(),
          
          const SizedBox(height: 16),
          
          // Account Status
          _buildAccountStatus(),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.person, 'User ID', widget.user.userId),
        _buildInfoRow(Icons.email, 'Email', widget.user.email),
        _buildInfoRow(Icons.calendar_today, 'Joined', _formatDate(widget.user.createdAt)),
      ],
    );
  }

  Widget _buildActivityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.login,
          'Last Login',
          widget.user.lastLogin != null 
              ? _formatDateTime(widget.user.lastLogin!)
              : 'Never',
        ),
        _buildInfoRow(
          Icons.access_time,
          'Account Age',
          _getAccountAge(widget.user.createdAt),
        ),
      ],
    );
  }

  Widget _buildAccountStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildStatusChip(
              'Email Verified',
              widget.user.emailVerified,
              widget.user.emailVerified ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            _buildStatusChip(
              'Account Status',
              !widget.user.isBlocked,
              widget.user.isBlocked ? Colors.red : Colors.green,
              activeText: 'Active',
              inactiveText: 'Blocked',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    String label,
    bool isActive,
    Color color, {
    String? activeText,
    String? inactiveText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? (activeText ?? 'Yes') : (inactiveText ?? 'No'),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _getAccountAge(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Today';
    }
  }

  void _showBlockDialog() {
    CustomDialog.show(
      context: context,
      title: "Block User",
      content: Text(
        "Are you sure you want to block ${widget.user.name}? They will not be able to access their account.",
      ),
      // onDone: () {
      //   context.read<UserManagementCubit>().updateUser(
      //     widget.user.copyWith(isBlocked: true),
      //   );
      // },
    );
  }

  void _showUnblockDialog() {
    CustomDialog.show(
      context: context,
      title: "Unblock User",
      content: Text(
        "Are you sure you want to unblock ${widget.user.name}? They will regain access to their account.",
      ),
      // onDone: () {
      //   context.read<UserManagementCubit>().updateUser(
      //     widget.user.copyWith(isBlocked: false),
      //   );
      // },
    );
  }
}

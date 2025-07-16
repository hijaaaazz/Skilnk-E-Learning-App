import 'package:admin_app/features/users/data/models/user-update_params.dart';
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

class _UserCardState extends State<UserCard> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(),
            SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: _buildExpandedDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: _buildProfileImage(),
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.user.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: widget.user.isBlocked ? Colors.grey[400] : Colors.black87,
                decoration: widget.user.isBlocked ? TextDecoration.lineThrough : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildStatusBadges(),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.email,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(),
          ],
        ),
      ),
      trailing: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: _animation,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
            isExpanded ? _animationController.forward() : _animationController.reverse();
          });
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.user.isBlocked
              ? Colors.red
              : widget.user.emailVerified
                  ? Colors.green
                  : Colors.grey,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: widget.user.image != null && widget.user.image!.isNotEmpty
            ? Image.network(
                widget.user.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.user.isBlocked
              ? [Colors.red[400]!, Colors.red[600]!]
              : [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadges() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.user.emailVerified && !widget.user.isBlocked)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.greenAccent],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Verified',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(width: 8),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Icon(
          widget.user.emailVerified ? Icons.email : Icons.email_outlined,
          size: 16,
          color: widget.user.emailVerified ? Colors.green : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          widget.user.emailVerified ? 'Email Verified' : 'Email Not Verified',
          style: TextStyle(
            fontSize: 12,
            color: widget.user.emailVerified ? Colors.green : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          widget.user.lastLogin != null ? Icons.access_time : Icons.access_time_outlined,
          size: 16,
          color: widget.user.lastLogin != null ? Colors.blue : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          widget.user.lastLogin != null
              ? 'Active ${_getTimeAgo(widget.user.lastLogin!)}'
              : 'Never logged in',
          style: TextStyle(
            fontSize: 12,
            color: widget.user.lastLogin != null ? Colors.blue : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.user.isBlocked ? _showUnblockDialog : _showBlockDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: widget.user.isBlocked
                  ? [Colors.green[400]!, Colors.green[600]!]
                  : [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.user.isBlocked ? Icons.check_circle : Icons.block,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                widget.user.isBlocked ? 'Unblock' : 'Block',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedDetails() {
    if (!isExpanded) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 16),
          _buildAccountInfo(),
          const SizedBox(height: 16),
          _buildActivityInfo(),
          const SizedBox(height: 16),
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
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
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
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          Icons.login,
          'Last Login',
          widget.user.lastLogin != null ? _formatDateTime(widget.user.lastLogin!) : 'Never',
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
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildStatusChip(
              'Email Verified',
              widget.user.emailVerified,
              Colors.green,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? (activeText ?? 'Yes') : (inactiveText ?? 'No'),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
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
      onDone: () {
        context.read<UserManagementCubit>().toggleBlock(
          UserUpdateParams(userId:  widget.user.userId,
          toggle:!widget.user.isBlocked)
            );
      },
    );
  }

  void _showUnblockDialog() {
    CustomDialog.show(
      context: context,
      title: "Unblock User",
      content: Text(
        "Are you sure you want to unblock ${widget.user.name}? They will regain access to their account.",
      ),
      onDone: () {
        context.read<UserManagementCubit>().toggleBlock(
          UserUpdateParams(userId:  widget.user.userId,
          toggle:!widget.user.isBlocked)
            );
      },
    );
  }
}
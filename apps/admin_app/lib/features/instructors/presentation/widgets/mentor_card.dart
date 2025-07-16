import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/common/widgets/app_text.dart';
import 'package:admin_app/common/widgets/dialog.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_cubit.dart';

class MentorCard extends StatefulWidget {
  final MentorEntity mentor;

  const MentorCard({
    Key? key,
    required this.mentor,
  }) : super(key: key);

  @override
  State<MentorCard> createState() => _MentorCardState();
}

class _MentorCardState extends State<MentorCard> with SingleTickerProviderStateMixin {
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
              widget.mentor.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              _buildBanCourse(),
              _buildActionButton(),
            ],
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mentor.email,
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
          color: widget.mentor.isVerified ? Colors.green : Colors.grey,
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
        child: widget.mentor.image != null && widget.mentor.image!.isNotEmpty
            ? Image.network(
                widget.mentor.image!,
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
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          widget.mentor.name.isNotEmpty ? widget.mentor.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Icon(
          widget.mentor.emailVerified ? Icons.email : Icons.email_outlined,
          size: 16,
          color: widget.mentor.emailVerified ? Colors.green : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Text(
          widget.mentor.emailVerified ? 'Email Verified' : 'Email Not Verified',
          style: TextStyle(
            fontSize: 12,
            color: widget.mentor.emailVerified ? Colors.green : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.school,
          size: 16,
          color: Colors.blue[600],
        ),
        const SizedBox(width: 6),
        Text(
          '${widget.mentor.courseIds?.length ?? 0} courses',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue[600],
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
        onTap: _showVerificationDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: widget.mentor.isVerified
                  ? [Colors.green[400]!, Colors.green[600]!]
                  : [Colors.blue[400]!, Colors.blue[600]!],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.mentor.isVerified ? Icons.check_circle : Icons.verified_user,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                widget.mentor.isVerified ? 'Verified' : 'Verify',
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
          if (widget.mentor.bio != null && widget.mentor.bio!.isNotEmpty)
            _buildDetailSection('Bio', widget.mentor.bio!),
          _buildContactInfo(),
          if (widget.mentor.categories != null && widget.mentor.categories!.isNotEmpty)
            _buildCategoriesSection(),
          _buildCourseInfo(),
          _buildTimestamps(),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email, 'Email', widget.mentor.email),
          if (widget.mentor.phone != null && widget.mentor.phone!.isNotEmpty)
            _buildInfoRow(Icons.phone, 'Phone', widget.mentor.phone!),
          if (widget.mentor.username != null && widget.mentor.username!.isNotEmpty)
            _buildInfoRow(Icons.person, 'Username', widget.mentor.username!),
        ],
      ),
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

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.mentor.categories!.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[100]!, Colors.blue[50]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo() {
    final courseCount = widget.mentor.courseIds?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Information',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.school, size: 16, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Total Courses: $courseCount',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamps() {
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
        _buildInfoRow(
          Icons.calendar_today,
          'Joined',
          _formatDate(widget.mentor.createdDate),
        ),
        _buildInfoRow(
          Icons.update,
          'Last Updated',
          _formatDate(widget.mentor.updatedDate),
        ),
        if (widget.mentor.lastActive != null)
          _buildInfoRow(
            Icons.access_time,
            'Last Active',
            _formatDate(widget.mentor.lastActive!),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showVerificationDialog() {
    CustomDialog.show(
      context: context,
      title: widget.mentor.isVerified ? "Unverify Mentor" : "Verify Mentor",
      content: Text(
        widget.mentor.isVerified
            ? "Are you sure you want to unverify this mentor?"
            : "Are you sure you want to verify this mentor?",
      ),
      onDone: () {
        context.read<MentorManagementCubit>().toggleVerification(
              widget.mentor.tutorId,
              !widget.mentor.isVerified,
            );
      },
    );
  }


  Widget _buildBanCourse() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.mentor.isblocked ? _showUnblockDialog : _showBlockDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: widget.mentor.isblocked
                  ? [Colors.green[400]!, Colors.green[600]!]
                  : [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.mentor.isblocked ? Icons.check_circle : Icons.block,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                widget.mentor.isblocked ? 'Unblock' : 'Block',
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

  void _showBlockDialog() {
    CustomDialog.show(
      context: context,
      title: "Block User",
      content: Text(
        "Are you sure you want to block ${widget.mentor.name}? They will not be able to access their account.",
      ),
      onDone: () {
        context.read<MentorManagementCubit>().toggleBlock(
              widget.mentor.tutorId,
              !widget.mentor.isblocked
            );
      },
    );
  }

  void _showUnblockDialog() {
    CustomDialog.show(
      context: context,
      title: "Unblock User",
      content: Text(
        "Are you sure you want to unblock ${widget.mentor.name}? They will regain access to their account.",
      ),
      onDone: () {
        context.read<MentorManagementCubit>().toggleBlock(
              widget.mentor.tutorId,
              !widget.mentor.isblocked
            );
      },
    );
  }
}
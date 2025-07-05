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

class _MentorCardState extends State<MentorCard> {
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
                    widget.mentor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  widget.mentor.email,
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
          color: widget.mentor.isVerified ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: widget.mentor.image != null && widget.mentor.image!.isNotEmpty
            ? Image.network(
                widget.mentor.image!,
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
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          widget.mentor.name.isNotEmpty ? widget.mentor.name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
          color: widget.mentor.emailVerified ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          widget.mentor.emailVerified ? 'Email Verified' : 'Email Not Verified',
          style: TextStyle(
            fontSize: 12,
            color: widget.mentor.emailVerified ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.school,
          size: 16,
          color: Colors.blue,
        ),
        const SizedBox(width: 4),
        Text(
          '${widget.mentor.courseIds?.length ?? 0} courses',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (widget.mentor.isVerified) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green),
        ),
        child: const Text(
          'Verified',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return TextButton.icon(
      onPressed: () => _showVerificationDialog(),
      icon: const Icon(Icons.verified_user, size: 16),
      label: const Text('Verify'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
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
          
          // Bio Section
          if (widget.mentor.bio != null && widget.mentor.bio!.isNotEmpty)
            _buildDetailSection('Bio', widget.mentor.bio!),
          
          // Contact Information
          _buildContactInfo(),
          
          // Categories
          if (widget.mentor.categories != null && widget.mentor.categories!.isNotEmpty)
            _buildCategoriesSection(),
          
          // Course Information
          _buildCourseInfo(),
          
          // Timestamps
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
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
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
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: widget.mentor.categories!.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
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
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.school, size: 16, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Total Courses: $courseCount',
                style: TextStyle(
                  fontSize: 13,
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
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
        context.read<MentorManagementCubit>().updateMentor(
          widget.mentor.copyWith(isVerified: !widget.mentor.isVerified),
          !widget.mentor.isVerified,
        );
      },
    );
  }
}

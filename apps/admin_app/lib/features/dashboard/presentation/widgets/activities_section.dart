import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_bloc.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitiesSection extends StatelessWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: TextStyle(color: Colors.red[700], fontSize: 16),
            ),
          );
        }

        if (state is DashboardLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.activities.length,
            itemBuilder: (context, index) {
              final activity = state.activities[index];
              return ActivityCard(activity: activity);
            },
          );
        }

        return const Center(
          child: Text(
            'No activities found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      },
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: _getActivityColor(activity.type),
            child: Icon(
              _getActivityIcon(activity.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getActivityColor(activity.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getActivityColor(activity.type).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _getActivityTypeName(activity.type),
                        style: TextStyle(
                          fontSize: 11,
                          color: _getActivityColor(activity.type),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(activity.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.courseUpload:
        return Colors.blue[600]!;
      case ActivityType.studentEnrollment:
        return Colors.green[600]!;
      case ActivityType.bannerUpdate:
        return Colors.orange[600]!;
      case ActivityType.mentorRegistration:
        return Colors.purple[600]!;
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.courseUpload:
        return Icons.school;
      case ActivityType.studentEnrollment:
        return Icons.person_add;
      case ActivityType.bannerUpdate:
        return Icons.image;
      case ActivityType.mentorRegistration:
        return Icons.person;
    }
  }

  String _getActivityTypeName(ActivityType type) {
    switch (type) {
      case ActivityType.courseUpload:
        return 'COURSE';
      case ActivityType.studentEnrollment:
        return 'ENROLLMENT';
      case ActivityType.bannerUpdate:
        return 'BANNER';
      case ActivityType.mentorRegistration:
        return 'MENTOR';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
}
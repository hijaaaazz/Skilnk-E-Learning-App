import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import  'package:user_app/features/account/data/models/activity_model.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_state.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';

class ProfileInfoSection extends StatelessWidget {
  final UserEntity user;

  const ProfileInfoSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader('Account Information'),
          buildInfoItem(
            Icons.calendar_today_outlined,
            'Joined',
            _formatDate(user.createdDate),
          ),
          const SizedBox(height: 24),
          _buildRecentActivitiesSection(context),
        ],
      ),
    );
  }

  Widget buildSectionHeader(String title, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.deepOrange.shade800,
        ),
      ),
    );
  }

  Widget buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.deepOrange.shade700, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              Text(
                value.isNotEmpty ? value : 'Not set',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: value.isNotEmpty ? Colors.black87 : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSectionHeader('Recent Enrollments', Colors.black),
          ],
        ),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileActivitiesLoading) {
              return _buildActivitiesLoadingState();
            } else if (state is ProfileActivitiesLoaded) {
              return _buildActivitiesList(state.activities);
            } else if (state is ProfileError) {
              return _buildActivitiesErrorState(context);
            } else {
              // Default state - show placeholder activities
              return _buildDefaultActivitiesState();
            }
          },
        ),
      ],
    );
  }

  Widget _buildActivitiesLoadingState() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 12,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActivitiesList(List<Activity> activities) {
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No recent activities',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        return _buildActivityItem(activity);
      }).toList(),
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActivityColor(activity.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              color: _getActivityColor(activity.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatRelativeTime(activity.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesErrorState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Failed to load activities',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileCubit>().fetchRecentActivities(
                userId: user.userId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultActivitiesState() {
    // Show the original static activities as fallback
    return Column(
      children: List.generate(3, (index) {
        return buildInfoItem(
          Icons.history,
          'Activity ${index + 1}',
          'Details of activity ${index + 1}',
        );
      }),
    );
  }

  // Helper methods
  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'profile':
        return Icons.person;
      case 'order':
        return Icons.shopping_cart;
      case 'security':
        return Icons.security;
      case 'auth':
        return Icons.login;
      case 'verification':
        return Icons.verified;
      default:
        return Icons.history;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'profile':
        return Colors.blue;
      case 'order':
        return Colors.green;
      case 'security':
        return Colors.orange;
      case 'auth':
        return Colors.purple;
      case 'verification':
        return Colors.teal;
      default:
        return Colors.deepOrange;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
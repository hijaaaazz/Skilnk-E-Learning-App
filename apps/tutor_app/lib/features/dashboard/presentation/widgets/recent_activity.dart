// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/activity_item.dart';

class ModernRecentActivity extends StatelessWidget {
  final List<ActivityItem> activities;

  const ModernRecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (activities.isEmpty)
            _buildEmptyState()
          else
            _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        ...activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;
          
          return _buildActivityItem(activity, isLast);
        }).toList(),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActivityItem(ActivityItem activity, bool isLast) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildActivityIcon(activity.action),
          SizedBox(width: 16),
          Expanded(
            child: _buildActivityContent(activity),
          ),
          _buildTimeStamp(activity.time),
        ],
      ),
    );
  }

  Widget _buildActivityIcon(String action) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (action.toLowerCase()) {
      case 'purchased a course':
      case 'purchased':
        iconData = Icons.shopping_bag_outlined;
        backgroundColor = Color(0xFF10B981).withOpacity(0.1);
        iconColor = Color(0xFF10B981);
        break;
      case 'enrolled':
        iconData = Icons.school_outlined;
        backgroundColor = Color(0xFF6366F1).withOpacity(0.1);
        iconColor = Color(0xFF6366F1);
        break;
      case 'completed':
        iconData = Icons.check_circle_outline;
        backgroundColor = Color(0xFFF59E0B).withOpacity(0.1);
        iconColor = Color(0xFFF59E0B);
        break;
      default:
        iconData = Icons.person_outline;
        backgroundColor = Color(0xFF6B7280).withOpacity(0.1);
        iconColor = Color(0xFF6B7280);
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildActivityContent(ActivityItem activity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: activity.userName,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: ' ${activity.action}'),
            ],
          ),
        ),
        SizedBox(height: 2),
        Text(
          activity.course,
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTimeStamp(String time) {
    // Parse and format the time to show relative time
    String formattedTime = _getRelativeTime(time);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        formattedTime,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  String _getRelativeTime(String timeString) {
    try {
      // Parse the time string (assuming format: "dd MMM yyyy, hh:mm a")
      final dateTime = DateFormat('dd MMM yyyy, hh:mm a').parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM dd').format(dateTime);
      }
    } catch (e) {
      return timeString;
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.history_outlined,
                size: 32,
                color: Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No recent activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Activity will appear here when students interact with your courses',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

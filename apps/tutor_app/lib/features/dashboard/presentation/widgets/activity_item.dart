import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';

class ActivityItemWidget extends StatelessWidget {
  final ActivityItem activity;

  const ActivityItemWidget({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFFF6636),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: activity.userName,
                        style: TextStyle(
                          color: Color(0xFF1D1F26),
                          fontSize: isMobile ? 12 : 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' ${activity.action} ',
                        style: TextStyle(
                          color: Color(0xFF4D5565),
                          fontSize: isMobile ? 12 : 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: activity.course,
                        style: TextStyle(
                          color: Color(0xFF1D1F26),
                          fontSize: isMobile ? 12 : 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  activity.time,
                  style: TextStyle(
                    color: Color(0xFF8C93A3),
                    fontSize: isMobile ? 10 : 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
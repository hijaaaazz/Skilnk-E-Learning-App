import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/activity_item.dart';
class RecentActivity extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivity({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: Color(0xFF1D1F26),
                    fontSize: isMobile ? 14 : 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: isMobile ? 12 : 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF6E7484),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.1),
            ),
            itemBuilder: (context, index) {
              return ActivityItemWidget(activity: activities[index]);
            },
          ),
        ],
      ),
    );
  }
}
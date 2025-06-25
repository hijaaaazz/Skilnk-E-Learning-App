import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/earning_card.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/stats-card.dart';
import '../../data/models/dashboard_data.dart';


class ModernStatsGrid extends StatelessWidget {
  final DashboardData data;
  final Function(TimePeriod)? onPeriodChanged;

  const ModernStatsGrid({
    Key? key,
    required this.data,
    this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Top row - Students and Courses
          Row(
            children: [
              Expanded(
                child: ModernStatCard(
                  value: data.metrics.totalStudents.toString(),
                  label: 'Students',
                  icon: Icons.people_outline,
                  color: Color(0xFF6366F1),
                  growth: data.growthData.hasComparisonData 
                      ? data.growthData.studentsGrowth
                      : null,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ModernStatCard(
                  value: data.metrics.totalCourses.toString(),
                  label: 'Courses',
                  icon: Icons.library_books_outlined,
                  color: Color(0xFF10B981),
                  growth: data.growthData.hasComparisonData 
                      ? data.growthData.coursesGrowth
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Bottom row - Sales
          ModernStatCard(
            value: data.metrics.totalCoursesSold.toString(),
            label: 'Sales',
            icon: Icons.trending_up,
            color: Color(0xFFF59E0B),
            growth: data.growthData.hasComparisonData 
                ? data.growthData.salesGrowth
                : null,
            isFullWidth: true,
          ),
          SizedBox(height: 20),
          
          // Earnings card - bigger and different
          ModernEarningsCard(
            data: data,
            onPeriodChanged: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/dashboard/data/models/chart_data.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_metrics.dart';
import 'package:tutor_app/features/dashboard/data/models/growth_data.dart';
import 'package:tutor_app/features/dashboard/data/models/insight_data.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';


class DashboardData extends Equatable {
  final DashboardMetrics metrics;
  final GrowthData growthData;
  final InsightsData insights;
  final ChartData earningsChart;
  final TimePeriod currentPeriod;
  final DateTime lastUpdated;

  const DashboardData({
    required this.metrics,
    required this.growthData,
    required this.insights,
    required this.earningsChart,
    required this.currentPeriod,
    required this.lastUpdated,
  });

  // Convenience getters for backward compatibility
  String get students => metrics.totalStudents.toString();
  String get courses => metrics.totalCourses.toString();
  String get totalEarning => metrics.totalEarnings.toStringAsFixed(2);
  String get courseSold => metrics.totalCoursesSold.toString();
  String get currentPeriodEarning => metrics.currentPeriodEarnings.toStringAsFixed(2);
  String get earningDescription => insights.primaryInsight;

  @override
  List<Object?> get props => [
        metrics,
        growthData,
        insights,
        earningsChart,
        currentPeriod,
        lastUpdated,
      ];
}

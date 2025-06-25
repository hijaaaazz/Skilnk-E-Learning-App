import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final int totalStudents;
  final int totalCourses;
  final double totalEarnings;
  final int totalCoursesSold;
  final double currentPeriodEarnings;
  final int currentPeriodStudents;
  final int currentPeriodCourses;
  final int currentPeriodSales;

  const DashboardMetrics({
    required this.totalStudents,
    required this.totalCourses,
    required this.totalEarnings,
    required this.totalCoursesSold,
    required this.currentPeriodEarnings,
    required this.currentPeriodStudents,
    required this.currentPeriodCourses,
    required this.currentPeriodSales,
  });


  @override
  List<Object?> get props => [
        totalStudents,
        totalCourses,
        totalEarnings,
        totalCoursesSold,
        currentPeriodEarnings,
        currentPeriodStudents,
        currentPeriodCourses,
        currentPeriodSales,
      ];
}

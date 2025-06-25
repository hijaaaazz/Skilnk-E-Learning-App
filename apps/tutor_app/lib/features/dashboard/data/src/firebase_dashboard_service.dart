import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/dashboard/data/models/insight_data.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../models/activity_item.dart';
import '../models/dashboard_data.dart';
import '../models/dashboard_metrics.dart';
import '../models/growth_data.dart';
import '../models/chart_data.dart';
import '../../domain/entity/dash_board_data_entity.dart';

abstract class FirebaseDashboardService {
  Future<Either<String, DashBoardDataEntity>> getDashBoardData(String mentorId, {TimePeriod? timePeriod});
  Future<Either<String, String>> getCourseName(String courseId);
  Future<Either<String, String>> getStudentName(String studentId);
}



class FirebaseDashboardServiceImp extends FirebaseDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, DashBoardDataEntity>> getDashBoardData(String mentorId, {TimePeriod? timePeriod}) async {
    try {
      final selectedPeriod = timePeriod ?? TimePeriod.thisMonth;
      final dateRange = DateRange.fromTimePeriod(selectedPeriod);
      
      // Fetch all enrollments for the mentor
      final allEnrollments = await _fetchAllEnrollments(mentorId);
      if (allEnrollments.isLeft()) {
        return Left(allEnrollments.swap().getOrElse(() => 'Unknown error'));
      }
      
      final enrollments = allEnrollments.getOrElse(() => []);
      
      // Calculate metrics
      final metrics = await _calculateMetrics(enrollments, dateRange);
      final growthData = await _calculateGrowthData(enrollments, dateRange);
      final insights = await _generateInsights(enrollments, dateRange, metrics, growthData);
      final chartData = await _generateChartData(enrollments, dateRange);
      final activities = await _getRecentActivities(enrollments.take(5).toList());

      final dashboardData = DashboardData(
        metrics: metrics,
        growthData: growthData,
        insights: insights,
        earningsChart: chartData,
        currentPeriod: selectedPeriod,
        lastUpdated: DateTime.now(),
      );

      log(dashboardData.toString());

      return Right(DashBoardDataEntity(
        activities: activities,
        data: dashboardData,
      ));
    } catch (e) {
      return Left('Error fetching dashboard data: $e');
    }
  }

  Future<Either<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>> _fetchAllEnrollments(String mentorId) async {
    try {
      final enrollments = await _firestore
          .collection('enrollments')
          .where('tutorId', isEqualTo: mentorId)
          .orderBy('timestamp', descending: true)
          .get();
      
      return Right(enrollments.docs);
    } catch (e) {
      return Left('Error fetching enrollments: $e');
    }
  }

  Future<DashboardMetrics> _calculateMetrics(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
    DateRange dateRange,
  ) async {
    final allUserIds = <String>{};
    final allCourseIds = <String>{};
    final currentPeriodUserIds = <String>{};
    final currentPeriodCourseIds = <String>{};
    
    double totalEarnings = 0;
    double currentPeriodEarnings = 0;
    int currentPeriodSales = 0;

    for (final doc in enrollments) {
      final data = doc.data();
      final courseId = data['courseId'] as String?;
      final userId = data['userId'] as String?;
      final amount = (data['amount'] as num?)?.toDouble() ?? 0;
      final timestamp = data['timestamp'] as Timestamp?;
      final purchaseDate = timestamp?.toDate();

      if (courseId != null) allCourseIds.add(courseId);
      if (userId != null) allUserIds.add(userId);
      totalEarnings += amount;

      if (purchaseDate != null && 
          purchaseDate.isAfter(dateRange.startDate) && 
          purchaseDate.isBefore(dateRange.endDate)) {
        currentPeriodEarnings += amount;
        currentPeriodSales++;
        if (userId != null) currentPeriodUserIds.add(userId);
        if (courseId != null) currentPeriodCourseIds.add(courseId);
      }
    }

    return DashboardMetrics(
      totalStudents: allUserIds.length,
      totalCourses: allCourseIds.length,
      totalEarnings: totalEarnings,
      totalCoursesSold: enrollments.length,
      currentPeriodEarnings: currentPeriodEarnings,
      currentPeriodStudents: currentPeriodUserIds.length,
      currentPeriodCourses: currentPeriodCourseIds.length,
      currentPeriodSales: currentPeriodSales,
    );
  }

  Future<GrowthData> _calculateGrowthData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
    DateRange dateRange,
  ) async {
    final comparisonRange = _getComparisonDateRange(dateRange);
    
    final comparisonUserIds = <String>{};
    final comparisonCourseIds = <String>{};
    double comparisonEarnings = 0;
    int comparisonSales = 0;

    for (final doc in enrollments) {
      final data = doc.data();
      final courseId = data['courseId'] as String?;
      final userId = data['userId'] as String?;
      final amount = (data['amount'] as num?)?.toDouble() ?? 0;
      final timestamp = data['timestamp'] as Timestamp?;
      final purchaseDate = timestamp?.toDate();

      if (purchaseDate != null && 
          purchaseDate.isAfter(comparisonRange.startDate) && 
          purchaseDate.isBefore(comparisonRange.endDate)) {
        comparisonEarnings += amount;
        comparisonSales++;
        if (userId != null) comparisonUserIds.add(userId);
        if (courseId != null) comparisonCourseIds.add(courseId);
      }
    }

    final hasComparisonData = comparisonEarnings > 0 || comparisonSales > 0;
    
    return GrowthData(
      studentsGrowth: _calculateGrowthPercentage(
        await _calculateMetrics(enrollments, dateRange).then((m) => m.currentPeriodStudents.toDouble()),
        comparisonUserIds.length.toDouble(),
      ),
      coursesGrowth: _calculateGrowthPercentage(
        await _calculateMetrics(enrollments, dateRange).then((m) => m.currentPeriodCourses.toDouble()),
        comparisonCourseIds.length.toDouble(),
      ),
      earningsGrowth: _calculateGrowthPercentage(
        await _calculateMetrics(enrollments, dateRange).then((m) => m.currentPeriodEarnings),
        comparisonEarnings,
      ),
      salesGrowth: _calculateGrowthPercentage(
        await _calculateMetrics(enrollments, dateRange).then((m) => m.currentPeriodSales.toDouble()),
        comparisonSales.toDouble(),
      ),
      hasComparisonData: hasComparisonData,
    );
  }

  double _calculateGrowthPercentage(double current, double previous) {
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  DateRange _getComparisonDateRange(DateRange currentRange) {
    final duration = currentRange.endDate.difference(currentRange.startDate);
    final comparisonEnd = currentRange.startDate;
    final comparisonStart = comparisonEnd.subtract(duration);
    
    return DateRange(
      startDate: comparisonStart,
      endDate: comparisonEnd,
      period: currentRange.period,
    );
  }

  Future<InsightsData> _generateInsights(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
    DateRange dateRange,
    DashboardMetrics metrics,
    GrowthData growthData,
  ) async {
    final insights = <String>[];
    String primaryInsight = 'No significant activity in the selected period.';
    String trendAnalysis = 'Insufficient data for trend analysis.';
    String recommendation = 'Focus on marketing and course promotion.';
    String peakPeriod = 'N/A';

    if (metrics.currentPeriodEarnings > 0) {
      primaryInsight = '${dateRange.period.displayName} earnings: \$${metrics.currentPeriodEarnings.toStringAsFixed(2)}';
      
      if (growthData.hasComparisonData) {
        if (growthData.earningsGrowth > 0) {
          trendAnalysis = 'Positive growth trend with ${growthData.earningsGrowth.toStringAsFixed(1)}% increase in earnings.';
          recommendation = 'Continue current strategies and consider scaling successful courses.';
        } else if (growthData.earningsGrowth < 0) {
          trendAnalysis = 'Declining trend with ${growthData.earningsGrowth.abs().toStringAsFixed(1)}% decrease in earnings.';
          recommendation = 'Review course content and implement promotional campaigns.';
        } else {
          trendAnalysis = 'Stable performance with consistent earnings.';
          recommendation = 'Explore new marketing channels to boost growth.';
        }
      }

      // Find peak period
      peakPeriod = await _findPeakPeriod(enrollments);
      
      insights.addAll([
        'Total students: ${metrics.totalStudents}',
        'Active courses: ${metrics.totalCourses}',
        'Sales this period: ${metrics.currentPeriodSales}',
      ]);
    }

    return InsightsData(
      primaryInsight: primaryInsight,
      trendAnalysis: trendAnalysis,
      recommendation: recommendation,
      peakPeriod: peakPeriod,
      keyHighlights: insights,
    );
  }

  Future<String> _findPeakPeriod(List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments) async {
    final dailyEarnings = <String, double>{};
    
    for (final doc in enrollments) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0;
      final timestamp = data['timestamp'] as Timestamp?;
      
      if (timestamp != null) {
        final date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
        dailyEarnings[date] = (dailyEarnings[date] ?? 0) + amount;
      }
    }
    
    if (dailyEarnings.isEmpty) return 'N/A';
    
    final peakDate = dailyEarnings.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return DateFormat('EEEE, MMM dd').format(DateTime.parse(peakDate));
  }

  Future<ChartData> _generateChartData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
    DateRange dateRange,
  ) async {
    final dataPoints = <ChartDataPoint>[];
    
    // Determine the number of periods to show based on the selected time period
    final periodsToShow = _getPeriodsToShow(dateRange.period);
    
    for (int i = periodsToShow - 1; i >= 0; i--) {
      final periodStart = _getPeriodStart(dateRange.period, i);
      final periodEnd = _getPeriodEnd(dateRange.period, i);
      double earnings = 0;
      
      for (final doc in enrollments) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0;
        final timestamp = data['timestamp'] as Timestamp?;
        final purchaseDate = timestamp?.toDate();
        
        if (purchaseDate != null && 
            purchaseDate.isAfter(periodStart) && 
            purchaseDate.isBefore(periodEnd)) {
          earnings += amount;
        }
      }
      
      dataPoints.add(ChartDataPoint(
        label: _getPeriodLabel(dateRange.period, i),
        value: earnings,
        date: periodStart,
        isCurrent: i == 0,
      ));
    }
    
    final maxValue = dataPoints.isEmpty ? 1.0 : dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    
    return ChartData(
      dataPoints: dataPoints,
      maxValue: maxValue,
      chartType: 'bar',
    );
  }

  int _getPeriodsToShow(TimePeriod period) {
    switch (period) {
      case TimePeriod.today:
        return 7; // Show 7 days
      case TimePeriod.thisWeek:
        return 4; // Show 4 weeks
      default:
        return 6; // Show 6 months
    }
  }

  DateTime _getPeriodStart(TimePeriod period, int periodsBack) {
    final now = DateTime.now();
    switch (period) {
      case TimePeriod.today:
        return DateTime(now.year, now.month, now.day - periodsBack);
      case TimePeriod.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return startOfWeek.subtract(Duration(days: 7 * periodsBack));
      default:
        return DateTime(now.year, now.month - periodsBack, 1);
    }
  }

  DateTime _getPeriodEnd(TimePeriod period, int periodsBack) {
    final start = _getPeriodStart(period, periodsBack);
    switch (period) {
      case TimePeriod.today:
        return start.add(Duration(days: 1));
      case TimePeriod.thisWeek:
        return start.add(Duration(days: 7));
      default:
        return DateTime(start.year, start.month + 1, 1);
    }
  }

  String _getPeriodLabel(TimePeriod period, int periodsBack) {
    final start = _getPeriodStart(period, periodsBack);
    switch (period) {
      case TimePeriod.today:
        return periodsBack == 0 ? 'Today' : DateFormat('EEE').format(start);
      case TimePeriod.thisWeek:
        return 'Week ${periodsBack + 1}';
      default:
        return DateFormat('MMM').format(start);
    }
  }

  Future<List<ActivityItem>> _getRecentActivities(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> enrollments,
  ) async {
    final activities = <ActivityItem>[];
    
    for (final doc in enrollments) {
      final data = doc.data();
      final courseId = data['courseId'] as String?;
      final userId = data['userId'] as String?;
      final timestamp = data['timestamp'] as Timestamp?;
      
      final formattedTime = timestamp != null
          ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
          : 'Unknown time';
      
      activities.add(ActivityItem(
        userName: userId ?? 'Unknown user',
        action: 'purchased a course',
        course: courseId ?? 'Unknown course',
        time: formattedTime,
      ));
    }
    
    return activities;
  }

  @override
  Future<Either<String, String>> getCourseName(String courseId) async {
    try {
      final courseDoc = await _firestore.collection('courses').doc(courseId).get();
      if (!courseDoc.exists) return Left('Course not found');
      final courseName = courseDoc.data()?['title'] as String?;
      if (courseName == null || courseName.isEmpty) return Left('Course name not available');
      return Right(courseName);
    } catch (e) {
      return Left('Error fetching course name: $e');
    }
  }

  @override
  Future<Either<String, String>> getStudentName(String studentId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(studentId).get();
      if (!userDoc.exists) return Left('User not found');
      final userData = userDoc.data();
      final name = userData?['name'] as String?;
      if (name == null || name.isEmpty) return Left('User name not available');
      return Right(name);
    } catch (e) {
      return Left('Error fetching user name: $e');
    }
  }
}

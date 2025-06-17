import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:tutor_app/features/dashboard/domain/entity/dash_board_data_entity.dart';

abstract class FirebaseDashboardService {
  Future<Either<String, DashBoardDataEntity>> getDashBoardData(String mentorId);
  Future<Either<String, String>> getCourseName(String courseId);
  Future<Either<String, String>> getStudentName(String studentId);
}

class FirebaseDashboardServiceImp extends FirebaseDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, DashBoardDataEntity>> getDashBoardData(String mentorId) async {
    try {
      final enrollments = await _firestore
          .collection('enrollments')
          .where('tutorId', isEqualTo: mentorId)
          .orderBy('timestamp', descending: true) // Show latest first
          .get();

      final courseIds = <String>{};
      final userIds = <String>{};
      final activityList = <ActivityItem>[];

      for (final doc in enrollments.docs) {
        final data = doc.data();

        // Add unique courseId and userId
        final courseId = data['courseId'] as String?;
        final userId = data['userId'] as String?;
        if (courseId != null) courseIds.add(courseId);
        if (userId != null) userIds.add(userId);

        // Format timestamp
        final timestamp = data['timestamp'] as Timestamp?;
        final formattedTime = timestamp != null
            ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
            : 'Unknown time';

        final activity = ActivityItem(
          userName: userId ?? 'Unknown user', // Fallback for null userId
          action: 'purchased a course',
          course: courseId ?? 'Unknown course', // Fallback for null courseId
          time: formattedTime,
        );
        activityList.add(activity);
      }

      // Calculate total earnings
      double totalEarnings = 0;
      double todayEarnings = 0;
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      for (final doc in enrollments.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0;
        totalEarnings += amount;

        // Check if purchase was made today
        final timestamp = data['timestamp'] as Timestamp?;
        if (timestamp != null) {
          final purchaseDate = timestamp.toDate();
          if (purchaseDate.isAfter(todayStart)) {
            todayEarnings += amount;
          }
        }
      }

      final dashboardData = DashboardData(
        students: userIds.length.toString(),
        courses: courseIds.length.toString(),
        totalEarning: totalEarnings.toStringAsFixed(2),
        courseSold: enrollments.docs.length.toString(),
        todayEarning: todayEarnings.toStringAsFixed(2),
        earningDescription: todayEarnings > 0
            ? 'Today\'s earnings: \$${todayEarnings.toStringAsFixed(2)}'
            : 'No earnings today',
      );

      return Right(
        DashBoardDataEntity(
          activities: activityList,
          data: dashboardData,
        ),
      );
    } catch (e) {
      return Left('Error fetching dashboard data: $e');
    }
  }

  @override
  Future<Either<String, String>> getCourseName(String courseId) async {
    try {
      final courseDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();

      if (!courseDoc.exists) {
        return Left('Course not found');
      }

      final courseName = courseDoc.data()?['title'] as String?;
      if (courseName == null || courseName.isEmpty) {
        return Left('Course name not available');
      }

      return Right(courseName);
    } catch (e) {
      return Left('Error fetching course name: $e');
    }
  }

  @override
  Future<Either<String, String>> getStudentName(String studentId) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(studentId)
          .get();

      if (!userDoc.exists) {
        return Left('User not found');
      }

      final userData = userDoc.data();
      final name = userData?['name'] as String?;

      if (name == null || name.isEmpty) {
        return Left('User name not available');
      }

      return Right(name);
    } catch (e) {
      return Left('Error fetching user name: $e');
    }
  }
}
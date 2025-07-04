import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class EnrollmentFirebaseService {
  Future<void> addPurchase({
    required String courseId,
    required String userId,
    required String tutorId,
    required double amount,
    String? purchaseId,
  });

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchCourse(String courseId);
  
  // New method to get user's enrolled courses
  Future<List<String>> getEnrolledCourseIds(String userId);

    // 👉 Updated return type
  Future<Either<String, bool>> updateEnrollStatus({
    required String courseId,
    required String userId,
    required bool isCompleted,
  });

  Future<Either<String,bool>> isCompleted(String userId, String courseId);
}


class EnrollmentFirebaseServiceImp extends EnrollmentFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPurchase({
    required String courseId,
    required String userId,
    required String tutorId,
    required double amount,
    String? purchaseId,
  }) async {
    final id = purchaseId ?? _firestore.collection('enrollments').doc().id;

    final purchaseData = {
      'courseId': courseId,
      'userId': userId,
      'tutorId': tutorId,
      'amount': amount,
      'purchaseId': id,
      'timestamp': FieldValue.serverTimestamp(),
    };

    log('[addPurchase] Generated Purchase ID: $id');
    log('[addPurchase] Purchase Data: $purchaseData');

    try {
      await _firestore.collection('enrollments').doc(id).set(purchaseData);
      log('[addPurchase] Purchase successfully added to Firestore');
    } catch (e) {
      log('[addPurchase] Failed to add purchase: $e');
      rethrow;
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchCourse(String courseId) async {
    log('[fetchCourse] Fetching course with ID: $courseId');

    try {
      final doc = await _firestore.collection('courses').doc(courseId).get();
      if (!doc.exists) {
        log('[fetchCourse] Course not found for ID: $courseId');
      } else {
        log('[fetchCourse] Course data fetched: ${doc.data()}');
      }
      return doc;
    } catch (e) {
      log('[fetchCourse] Error fetching course: $e');
      rethrow;
    }
  }
  
  @override
  Future<List<String>> getEnrolledCourseIds(String userId) async {
    log('[getEnrolledCourseIds] Fetching enrolled courses for user: $userId');

    try {
      final querySnapshot = await _firestore
          .collection('enrollments')
          .where('userId', isEqualTo: userId)
          .get();

      final courseIds = querySnapshot.docs
          .map((doc) => doc.data()['courseId'] as String)
          .toList();

      log('[getEnrolledCourseIds] Found ${courseIds.length} enrolled courses');
      return courseIds;
    } catch (e) {
      log('[getEnrolledCourseIds] Error fetching enrolled courses: $e');
      rethrow;
    }
  }
  
  @override
Future<Either<String, bool>> updateEnrollStatus({
  required String courseId,
  required String userId,
  required bool isCompleted,
}) async {
  log('[updateEnrollStatus] Updating status for user: $userId and course: $courseId');

  try {
    final querySnapshot = await _firestore
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'isCompleted': isCompleted,
        'completedAt': FieldValue.serverTimestamp(), // optional
      });

      log('[updateEnrollStatus] Enrollment marked as completed');
      return Right(true); // ✅ success
    } else {
      log('[updateEnrollStatus] Enrollment document not found');
      return Left('Enrollment document not found'); // ❌ failure
    }
  } catch (e) {
    log('[updateEnrollStatus] Error updating enrollment: $e');
    return Left('Error updating enrollment: ${e.toString()}');
  }
}

  @override
Future<Either<String, bool>> isCompleted(String userId, String courseId) async {
  log('[isCompleted] Checking if course "$courseId" is completed for user: $userId');

  try {
    final querySnapshot = await _firestore
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      log('[isCompleted] No enrollment found for this course and user.');
      return const Right(false);
    }

    final data = querySnapshot.docs.first.data();
    final isCompleted = data['isCompleted'] ?? false;

    log('[isCompleted] Status: $isCompleted');
    return Right(isCompleted as bool);
  } catch (e) {
    log('[isCompleted] Error: $e');
    return Left('Failed to fetch course completion status');
  }
}


}

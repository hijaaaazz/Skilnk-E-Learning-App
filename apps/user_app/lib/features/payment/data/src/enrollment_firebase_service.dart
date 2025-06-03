import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'dart:developer';

abstract class CoursesFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getCategories();
  Future<Either<String, List<Map<String, dynamic>>>> getCourses();
  Future<Either<String, Map<String, dynamic>>> getCourseDetails(String id);
  Future<Either<String, Map<String, dynamic>>> getMentor(String mentorId);
  Future<Either<String, Map<String, dynamic>>> saveCourseDetails(
      SaveCourseParams params);
  Future<Either<String, bool>> checkIsSaved(String courseId, String userId);
  Future<Either<String, bool>> checkIsEnrolled(String courseId, String userId);
}

class CoursesFirebaseServicesImp extends CoursesFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();
      final categories = querySnapshot.docs.map((doc) => doc.data()).toList();
      log(categories.toString());
      return Right(categories);
    } catch (e) {
      log("Error fetching categories: $e");
      return Left("Failed to fetch categories: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();
      final courses = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
      log(courses.toString());
      return Right(courses);
    } catch (e) {
      log("Error fetching courses: $e");
      return Left("Failed to fetch courses: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getCourseDetails(
      String courseId) async {
    try {
      log("getCourseDetails call started");
      final docSnapshot = await _firestore.collection('courses').doc(courseId).get();

      if (!docSnapshot.exists) {
        return Left("Course not found");
      }

      final courseData = {'id': docSnapshot.id, ...docSnapshot.data()!};
      log("Fetched course details for courseId: $courseId");
      return Right(courseData);
    } catch (e) {
      log("Error fetching course details: $e");
      return Left("Failed to fetch course details: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getMentor(String mentorId) async {
    try {
      log("getMentor call started");
      final doc = await _firestore.collection('mentors').doc(mentorId).get();

      if (doc.exists && doc.data() != null) {
        final mentorData = doc.data()!;
        return Right(mentorData);
      } else {
        return Left('Mentor not found');
      }
    } catch (e) {
      log("Error fetching mentor: $e");
      return Left('Error fetching mentor: $e');
    }
  }

  @override
  Future<Either<String, bool>> checkIsSaved(String courseId, String userId) async {
    try {
      log("checkIsSaved call started for courseId: $courseId, userId: $userId");
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        log("User document not found");
        return Right(false);
      }

      final userData = userDoc.data();
      final savedCourses = userData?['savedCourses'] as List<dynamic>? ?? [];
      final isSaved = savedCourses.contains(courseId);
      log("Course $courseId is ${isSaved ? 'saved' : 'not saved'} for user $userId");
      return Right(isSaved);
    } catch (e) {
      log("Error checking if course is saved: $e");
      return Left("Failed to check saved status: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> saveCourseDetails(
      SaveCourseParams params) async {
    try {
      log("saveCourseDetails call started");
      final userRef = _firestore.collection('users').doc(params.userId);

      await userRef.update({
        'savedCourses': params.isSave
            ? FieldValue.arrayUnion([params.courseId])
            : FieldValue.arrayRemove([params.courseId]),
      });

      log(params.isSave
          ? "Course ID ${params.courseId} added to user ${params.userId}'s savedCourses"
          : "Course ID ${params.courseId} removed from user ${params.userId}'s savedCourses");

      final docSnapshot =
          await _firestore.collection('courses').doc(params.courseId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Left("Course not found");
      }

      final courseData = {'id': docSnapshot.id, ...docSnapshot.data()!};
      log("Course save/unsave operation completed for courseId: ${params.courseId}");
      return Right(courseData);
    } catch (e) {
      log("Error in saveCourseDetails: $e");
      return Left("Failed to update saved course: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, bool>> checkIsEnrolled(
      String courseId, String userId) async {
    try {
      log("checkIsEnrolled called for courseId: $courseId, userId: $userId");
      final query = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      final isEnrolled = query.docs.isNotEmpty;
      log("Course $courseId is ${isEnrolled ? '' : 'not '}enrolled by user $userId");
      return Right(isEnrolled);
    } catch (e) {
      log("Error checking enrollment status: $e");
      return Left("Failed to check enrollment status: ${e.toString()}");
    }
  }
}
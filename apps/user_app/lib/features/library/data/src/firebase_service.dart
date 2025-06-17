import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

abstract class LibraryFirebaseService{
  Future<Either<String ,List<String>>>getSavedCoursesIds(String userId);
  Future<Either<String,List<CoursePreview>>>getSavedCourses(List<String> courseIds);
}

class LibraryFirebaseServiceImp extends LibraryFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
Future<Either<String, List<String>>> getSavedCoursesIds(String userId) async {
  try {
    log("Fetching saved courses for user: $userId");

    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (!userDoc.exists || userDoc.data() == null) {
      log("User document not found or empty");
      return Left("User not found");
    }

    final userData = userDoc.data()!;
    final savedCoursesDynamic = userData['savedCourses'] as List<dynamic>?;

    if (savedCoursesDynamic == null) {
      log("No saved courses found");
      return Right([]);
    }

    final savedCourses = savedCoursesDynamic.cast<String>();
    log("Saved courses: $savedCourses");

    return Right(savedCourses);
  } catch (e) {
    log("Error fetching saved courses: $e");
    return Left("Failed to get saved courses: ${e.toString()}");
  }
}

  @override
Future<Either<String, List<CoursePreview>>> getSavedCourses(List<String> courseIds) async {
  try {
    if (courseIds.isEmpty) {
      return Right([]);
    }

    log("Fetching saved courses for IDs: $courseIds");

    // Firestore supports whereIn with up to 10 elements
    final querySnapshot = await _firestore
        .collection('courses')
        .where(FieldPath.documentId, whereIn: courseIds).limit(3)
        .get();

    final savedCourses = querySnapshot.docs.map((doc) {
      return CoursePreview(
        id: doc.id,
        courseTitle: doc['title'],
        thumbnail: doc['course_thumbnail'],
        averageRating: (doc['average_rating'] ?? 0).toDouble(),
        price: (doc['price'] ?? 0).toString(),
        categoryname: doc['category_name'],
      );
    }).toList();

    log("Fetched ${savedCourses.length} saved courses.");

    return Right(savedCourses);
  } catch (e) {
    log("Error fetching saved courses: $e");
    return Left("Failed to fetch saved courses: ${e.toString()}");
  }
}

  

}
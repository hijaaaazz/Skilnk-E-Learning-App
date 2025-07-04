import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/course_list/data/models/load_course_params.dart';
import 'package:user_app/features/home/data/models/mentor_mode.dart';
import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'dart:developer';

import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/domain/usecases/get_reviews.dart';

abstract class CoursesFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getCategories();
  Future<Either<String, List<Map<String, dynamic>>>> getCourses();
  Future<Either<String, Map<String, dynamic>>> getCourseDetails(String id);
  Future<Either<String, Map<String, dynamic>>> getMentor(String mentorId);
  Future<Either<String, Map<String, dynamic>>> saveCourseDetails(
      SaveCourseParams params);
  Future<Either<String, bool>> checkIsSaved(String courseId, String userId);
  Future<Either<String, bool>> checkIsEnrolled(String courseId, String userId);
  Future<Either<String, List<MentorEntity>>> getMentors();
  Future<Either<String, List<CoursePreview>>> getMentorCourses(List<String> ids);
  Future<Either<String, Map<String, dynamic>>> getCourseList({
  required LoadCourseParams params
});
  Future<Either<String, List<ReviewModel>>> getReviews(GetReviewsParams params);
  Future<Either<String,ReviewModel>> addReview(ReviewModel review);
}

class CoursesFirebaseServicesImp extends CoursesFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').limit(3).get();
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
      final querySnapshot = await _firestore
    .collection('courses')
    .where('listed', isEqualTo: true)
    .where('isBanned', isEqualTo: false)
    .limit(3)
    .get();

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
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        log("User document not found");
        return Right(false);
      }

      final userData = userDoc.data();
      final savedCourses = userData?['savedCourses'] as List<dynamic>? ?? [];
      final isSaved = savedCourses.contains(courseId);
      return Right(isSaved);
    } catch (e) {
      return Left("Failed to check saved status: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> saveCourseDetails(
      SaveCourseParams params) async {
    try {
     
      final userRef = _firestore.collection('users').doc(params.userId);

      await userRef.update({
        'savedCourses': params.isSave
            ? FieldValue.arrayUnion([params.courseId])
            : FieldValue.arrayRemove([params.courseId]),
      });

     

      final docSnapshot =
          await _firestore.collection('courses').doc(params.courseId).get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return Left("Course not found");
      }

      final courseData = {'id': docSnapshot.id, ...docSnapshot.data()!};
      return Right(courseData);
    } catch (e) {
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
      return Right(isEnrolled);
    } catch (e) {
      return Left("Failed to check enrollment status: ${e.toString()}");
    }
  }
  
  @override
Future<Either<String, List<MentorEntity>>> getMentors() async {
  try {
    log("getMentors call started");

    final querySnapshot = await _firestore.collection('mentors').limit(3).get();

    final docs = querySnapshot.docs;

    if (docs.isEmpty) {
      return Left("No mentors found");
    }

    final mentors = docs
        .map((doc) => MentorModel.fromJson(doc.data()).toEntity())
        .toList();

    return Right(mentors);
  } catch (e) {
    log("Error fetching mentors: $e");
    return Left("Error fetching mentors: $e");
  }
}

  @override
Future<Either<String, List<CoursePreview>>> getMentorCourses(List<String> ids) async {
  try {
    log("getMentorCourses call started");

    if (ids.isEmpty) {
      return Left("No course IDs provided");
    }

    final limitedIds = ids.take(2).toList();

    final List<CoursePreview> courses = [];

    for (String id in limitedIds) {
      final docSnapshot = await _firestore.collection('courses').doc(id).get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        
        final course = CoursePreview(
          id: docSnapshot.id,
          courseTitle: data['title'],
          thumbnail: data['course_thumbnail'] ?? '',
          averageRating: (data['average_rating'] ?? 0).toDouble(),
          categoryname: data['category_name'] ?? '',
          price: data['price']?.toString() ?? 'Free',
          isComplted: data['isCompelted'] ?? false
        );

        courses.add(course);
      } else {
        log("Course with ID $id not found");
      }
    }

    if (courses.isEmpty) {
      return Left("No valid courses found for the given IDs");
    }

    return Right(courses);
  } catch (e) {
    log("Error fetching mentor courses: $e");
    return Left("Error fetching mentor courses: $e");
  }
}

  @override
Future<Either<String, Map<String, dynamic>>> getCourseList({
  required LoadCourseParams params,
}) async {
  try {
    if (params.courseIds.isEmpty) {
      return Right({'courses': [], 'lastDoc': null});
    }

    Query query = _firestore
        .collection('courses')
        .where(FieldPath.documentId, whereIn: params.courseIds)
        .where('listed', isEqualTo: true)
        .where('isBanned', isEqualTo: false)
        .orderBy('createdAt', descending: true);

    final snapshot = await query.get();

    final courses = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return CoursePreview(
        isComplted: data['isCompelted'] ?? false,
        id: doc.id,
        courseTitle: data['title'] ?? '',
        thumbnail: data['course_thumbnail'] ?? '',
        averageRating: (data['average_rating'] ?? 0).toDouble(),
        price: (data['price'] ?? 0).toString(),
        categoryname: data['category_name'] ?? '',
      );
    }).toList();

    log("Fetched ${courses.length} courses for batch: ${params.courseIds}");

    return Right({
      'courses': courses,
      'lastDoc': null,
    });
  } catch (e) {
    return Left("Failed to fetch courses: ${e.toString()}");
  }
}

// Implementation in the repository (assuming Firebase service)

@override
Future<Either<String, List<ReviewModel>>> getReviews(GetReviewsParams params) async {
  try {
    Query query = FirebaseFirestore.instance
        .collection('reviews')
        .where('courseId', isEqualTo: params.courseId)
        .orderBy('reviewedAt', descending: true)
        .limit(params.limit);

    // Apply pagination by skipping previous pages
    if (params.page > 1) {
      final skipCount = (params.page - 1) * params.limit;
      final lastDocSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('courseId', isEqualTo: params.courseId)
          .orderBy('reviewedAt', descending: true)
          .limit(skipCount)
          .get();

      if (lastDocSnapshot.docs.isNotEmpty) {
        query = query.startAfterDocument(lastDocSnapshot.docs.last);
      }
    }

    final snapshot = await query.get();

    final reviews = snapshot.docs.map((doc) {
      return ReviewModel.fromJson(doc.data() as Map<String, dynamic>, params.courseId);
    }).toList();

    log('Loaded ${reviews.length} reviews for page ${params.page}');

    return Right(reviews);
  } catch (e) {
    log('Error loading reviews: $e');
    return Left('Failed to load reviews: ${e.toString()}');
  }
}

  @override
Future<Either<String, ReviewModel>> addReview(ReviewModel review) async {
  try {
    await FirebaseFirestore.instance
        .collection('reviews')
        .add(review.toJson());

    return Right(review); // Return the same review that was set
  } catch (e) {
    return Left('Failed to add review: ${e.toString()}');
  }
}

  

}





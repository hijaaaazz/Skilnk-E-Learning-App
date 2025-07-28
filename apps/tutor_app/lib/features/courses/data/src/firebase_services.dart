import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_model.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/data/models/lang_model.dart';
import 'package:tutor_app/features/courses/data/models/lecture_model.dart';
import 'package:tutor_app/features/courses/data/models/review_model.dart';
import 'package:tutor_app/features/courses/data/models/toggle_params.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';

abstract class CourseFirebaseService {
  Future<Either<String, CourseOptionsModel>> getCourseOptions();
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, List<CoursePreview>>> getCourses({required CourseParams params});
  Future<Either<String, CourseModel>> getCourseDetails({required String courseId});
  Future<Either<String, CourseModel>> createCourse(CourseCreationReq req);
  Future<Either<String, bool>> deleteCourse(String courseId);
  Future<Either<String, CourseModel>> updateCourse(CourseModel req);
  Future<Either<String, bool>> activateToggleCourse(courseToggleParams req);
  Future<Either<String, List<ReviewModel>>> getReviews(List<String> ids);
  
  Future<Either<String, bool>> updateCategoryWithCourse({
    required String categoryId,
    required String courseId,
  });
  
  Future<Either<String, bool>> removeCourseFromCategory({
    required String categoryId,
    required String courseId,
  });

  Future<Either<String, bool>> saveCourseForUser({
  required String userId,
  required String courseId,
});

}

class CoursesFirebaseServiceImpl extends CourseFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, CourseOptionsModel>> getCourseOptions() async {
    try {
      final docSnapshot =
          await _firestore.collection('course_options').doc('options').get();

      final data = docSnapshot.data();
      log(data.toString());

      if (data == null) {
        return Right(CourseOptionsModel(categories: [], langs: [], levels: []));
      }

      final List<LanguageModel> langs =
          (data['languages'] as List<dynamic>?)
                  ?.map((e) =>
                      LanguageModel.fromJson(Map<String, dynamic>.from(e)))
                  .toList() ??
              [];

      final List<String> levels =
          (data['levels'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

      return Right(CourseOptionsModel(categories: [], langs: langs, levels: levels));
    } catch (e) {
      log("Error fetching course options: $e");
      return Left("Error: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();

      final categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromJson({
                ...doc.data(),
                'id': doc.id, // set doc ID inside the object
              }))
          .toList();

      return Right(categories);
    } catch (e) {
      log("Error fetching categories: $e");
      return Left("Failed to fetch categories: ${e.toString()}");
    }
  }
  
  @override
  Future<Either<String, CourseModel>> createCourse(CourseCreationReq req) async {
    try {
      // First, validate the input
      if (req.title == null || req.title!.isEmpty) {
        return Left("Course title is required");
      }
      if (req.categoryId == null || req.categoryId!.isEmpty) {
        return Left("Category is required");
      }
      if (req.tutorId == null || req.tutorId!.isEmpty) {
        return Left("Tutor ID is required");
      }
      
    
      
      // Calculate duration in minutes from seconds (rounded up)
      
      // Create course model
      final courseModel = CourseModel(
        id: '', // Will be set after Firestore creates document
        title: req.title ?? '',
        categoryId: req.categoryId ?? '',
        description: req.description ?? '',
        price: int.tryParse(req.price ?? "") ?? 0,
        offerPercentage: req.offerPercentage ?? 0,
        tutorId: req.tutorId ?? '',
        duration: req.duration!.inSeconds,
        categoryName: req.categoryName,
        enrolledCount: 0,
        averageRating: 0.0,
        ratingBreakdown: {
          "five_star": 0,
          "four_star": 0,
          "three_star": 0,
          "two_star": 0,
          "one_star": 0,
        },
        totalReviews: 0,
        reviews: [],
        lessons: req.lectures!.map((lecture) => LectureModel(
          title: lecture.title ?? '',
          description: lecture.description ?? '',
          videoUrl: lecture.videoUrl ?? '',
          notesUrl: lecture.notesUrl ?? '',
          durationInSeconds: lecture.duration?.inSeconds ?? 0,
        )).toList(),
        courseThumbnail: req.courseThumbnail ?? '',
        level: req.level ?? '',
        language: req.language ?? '',
        notificationSent: false,
        listed: false,
        isBanned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Convert to map for Firestore (using the toJson method)
      final courseData = courseModel.toCreateJson();
      
      // Add course to Firestore
      final courseRef = await _firestore.collection('courses').add(courseData);
      
      // Fetch the created course
      final courseDoc = await courseRef.get();
      final courseData2 = courseDoc.data();
      
      if (courseData2 == null) {
        return Left("Failed to retrieve created course");
      }
      
      // Use the fromJson method to create the CourseModel instance
      final gotcourseModel = CourseModel.fromJson(courseData2, courseRef.id);
      
      return Right(gotcourseModel);
    } catch (e) {
      log("Error creating course: $e");
      return Left("Failed to create course: ${e.toString()}");
    }
  }
  
@override
Future<Either<String, List<CoursePreview>>> getCourses({
  required CourseParams params,
}) async {
  log(params.tutorId ?? "No tutor id passed");

  if (params.tutorId == null) {
    return Left("Tutor ID is required");
  }

  try {
    Query query = _firestore
        .collection('courses')
        .where('tutor', isEqualTo: params.tutorId);

    // if (params.lastDoc != null) {
    //   query = query.startAfterDocument(params.lastDoc!);
    // }

    final querySnapshot = await query.get();

    log(querySnapshot.toString());

    final previews = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      log(data['title']);
      log(data.length.toString());

      return CoursePreview(
        id: doc.id,
        listed: data['listed'],
        title: data['title'] ?? '',
        thumbnailUrl: data['course_thumbnail'] ?? '',
        offerPercentage: data['offer_percentage'] ?? 0,
        rating: calculateAverageRating(data['rating_breakdown'] ?? 0),
        level: data['level'],
      );
    }).toList();

    return Right(previews);
  } catch (e) {
    log("Pagination error: $e");
    return Left("Failed to load courses: ${e.toString()}");
  }
}


double calculateAverageRating(Map<String, dynamic> ratings) {
  final ratingKeys = {
    'one_star': 1,
    'two_star': 2,
    'three_star': 3,
    'four_star': 4,
    'five_star': 5,
  };

  int totalScore = 0;
  int totalCount = 0;

  ratings.forEach((key, value) {
    final star = ratingKeys[key];
    final count = int.tryParse(value.toString()) ?? 0;

    if (star != null) {
      totalScore += star * count;
      totalCount += count;
    }
  });

  if (totalCount == 0) return 0.0;

  return totalScore / totalCount;
}

@override
Future<Either<String, CourseModel>> getCourseDetails({required String courseId}) async {
  try {
    // Fetch course document
    final docRef = _firestore.collection('courses').doc(courseId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return Left("Course with ID $courseId not found");
    }

    final data = docSnapshot.data()!;

    // Fetch reviews from the reviews collection
    final reviewsQuery = await _firestore
        .collection('reviews')
        .where('courseId', isEqualTo: courseId)
        .get();

    // Extract review IDs
    final reviewIds = reviewsQuery.docs.map((doc) => doc.id).toList();

    // Calculate average rating
    double averageRating = 0.0;
    if (reviewsQuery.docs.isNotEmpty) {
      final totalRating = reviewsQuery.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['rating']?.toDouble() ?? 0.0),
      );
      averageRating = totalRating / reviewsQuery.docs.length;
    }

    // Fetch enrollment count from the enrollments collection
    final enrollmentsQuery = await _firestore
        .collection('enrollments')
        .where('courseId', isEqualTo: courseId)
        .get();

    // Count enrollments
    final enrolledCount = enrollmentsQuery.docs.length;

    // Create CourseModel with review IDs, enrollment count, and average rating
    final courseModel = CourseModel.fromJson(data, docSnapshot.id).copyWith(
      reviews: reviewIds,
      enrolledCount: enrolledCount,
      averageRating: averageRating,
    );

    return Right(courseModel);
  } catch (e) {
    log("Error fetching course details: $e");
    return Left("Failed to fetch course details: ${e.toString()}");
  }
}

@override
  Future<Either<String, bool>> deleteCourse(String courseId) async {
  try {
    final docRef = _firestore.collection('courses').doc(courseId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      return Left("Course not found");
    }
    
    final data = docSnapshot.data();
    if (data == null) {
      return Left("Course data not found");
    }
    
    final enrolledCount = data['enrolled_count'] ?? 0;
    
    if (enrolledCount > 0) {
      return Left("Cannot delete a course with enrolled students");
    }

    await docRef.delete();
    return Right(true);
  } catch (e) {
    log("Error deleting course: $e");
    return Left("Failed to delete course: ${e.toString()}");
  }
}

@override
Future<Either<String, CourseModel>> updateCourse(CourseModel req) async {
  try {
    // Log the incoming request object
    log("updateCourse called with req: ${req.toString()}");
    
    
    if (req.id.isEmpty) {
      return Left("Course ID is required for update");
    }

    final docRef = _firestore.collection('courses').doc(req.id);
    log("Trying to get document at path: ${docRef.path}");
    
    final docSnapshot = await docRef.get();
    log("Document exists: ${docSnapshot.exists}");

    if (!docSnapshot.exists) {
      return Left("Course with ID ${req.id} not found");
    }

    // Convert to JSON and inspect before update
    final reqJson = req.toUpdateJson();
    log("req.toJson() result: $reqJson");
    
    // Check for null values in key fields
    reqJson.forEach((key, value) {
      if (value == null) {
        log("WARNING: Null value found for key: $key");
      }
    });

    // Update timestamp
    final updatedData = {
      ...reqJson,
      'updatedAt': DateTime.now(),
    };
    
    log("Attempting to update with data: $updatedData");
    
    // Perform the update
    try {
      await docRef.update(updatedData);
      log("Update successful");
    } catch (updateError) {
      log("Error during update operation: $updateError");
      return Left("Failed to update document: $updateError");
    }

    // Fetch the updated course
    log("Fetching updated document");
    final updatedDoc = await docRef.get();
    
    final updatedModelData = updatedDoc.data();
    log("updatedModelData: $updatedModelData");
    
    if (updatedModelData == null) {
      return Left("Course data not found in the document");
    }

    // Try/catch around fromJson to catch any conversion errors
    try {
      log("Creating CourseModel from JSON with ID: ${updatedDoc.id}");
      final updatedModel = CourseModel.fromJson(updatedModelData, updatedDoc.id);
      log("CourseModel created successfully");
      return Right(updatedModel);
    } catch (conversionError, stackTrace) {
      log("Error converting JSON to CourseModel: $conversionError");
      log("Stack trace: $stackTrace");
      log("JSON that failed conversion: $updatedModelData");
      return Left("Failed to convert document data to CourseModel: $conversionError");
    }
  } catch (e, stackTrace) {
    log("Error updating course: $e");
    log("Stack trace: $stackTrace");
    return Left("Failed to update course: ${e.toString()}");
  }
}
@override
Future<Either<String, bool>> updateCategoryWithCourse({
  required String categoryId,
  required String courseId,
}) async {
  try {
    // Reference to the category document
    final categoryDocRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId);
    
    // Get the current category document
    final categorySnapshot = await categoryDocRef.get();
    
    if (!categorySnapshot.exists) {
      log('Category with ID $categoryId does not exist');
      return const Left('Category not found');
    }
    
    // Get the current courses list from the category
    Map<String, dynamic> data = categorySnapshot.data() as Map<String, dynamic>;
    List<dynamic> courses = data['courses'] ?? [];
    
    // Check if the course is already in the list
    if (!courses.contains(courseId)) {
      // Add the course ID to the courses list
      courses.add(courseId);
      
      // Update the category document with the new courses list
      await categoryDocRef.update({'courses': courses});
      log('Added course $courseId to category $categoryId');
      return const Right(true);
    } else {
      // Course already in the category, no need to update
      log('Course $courseId already in category $categoryId');
      return const Right(true);
    }
  } catch (e) {
    log('Error updating category with course: $e');
    return Left('Failed to update category with course: $e');
  }
}

@override
Future<Either<String, bool>> removeCourseFromCategory({
  required String categoryId,
  required String courseId,
}) async {
  try {
    // Reference to the category document
    final categoryDocRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId);
    
    // Get the current category document
    final categorySnapshot = await categoryDocRef.get();
    
    if (!categorySnapshot.exists) {
      log('Category with ID $categoryId does not exist');
      return const Left('Category not found');
    }
    
    // Get the current courses list from the category
    Map<String, dynamic> data = categorySnapshot.data() as Map<String, dynamic>;
    List<dynamic> courses = List<dynamic>.from(data['courses'] ?? []);
    
    // Remove the course ID if it exists in the list
    if (courses.contains(courseId)) {
      courses.remove(courseId);
      
      // Update the category document with the modified courses list
      await categoryDocRef.update({'courses': courses});
      log('Removed course $courseId from category $categoryId');
      return const Right(true);
    } else {
      // Course not in the category, no need to update
      log('Course $courseId not found in category $categoryId');
      return const Right(true);
    }
  } catch (e) {
    log('Error removing course from category: $e');
    return Left('Failed to remove course from category: $e');
  }
}

  @override
Future<Either<String, bool>> activateToggleCourse(courseToggleParams req) async {
  try {
  
    String courseId = req.courseId; // Replace with actual course ID parameter
    
    final docRef = _firestore.collection('courses').doc(courseId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      return Left("Course not found");
    }

    // Update only the isActive field
    await docRef.update({
      'listed': req.isActive,
      'updatedAt': DateTime.now(),
    });
    
    return Right(true);
  } catch (e) {
    log("Error toggling course active status: $e");
    return Left("Failed to toggle course active status: ${e.toString()}");
  }
}

  @override
Future<Either<String, bool>> saveCourseForUser({
  required String userId,
  required String courseId,
}) async {
  try {
    log("course adding started in mentor collection");
    final userDoc = FirebaseFirestore.instance.collection('mentors').doc(userId);
    await userDoc.update({
      'courses': FieldValue.arrayUnion([courseId]),
    });
    return Right(true);
  } catch (e) {
    return Left("Failed to save course: ${e.toString()}");
  }
}

@override
Future<Either<String, List<ReviewModel>>> getReviews(List<String> ids) async {
  try {
    if (ids.isEmpty) {
      return Right([]);
    }

    final reviewsQuery = await _firestore
        .collection('reviews')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    final reviews = reviewsQuery.docs
        .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
        .toList();

    return Right(reviews);
  } catch (e) {
    log("Error fetching reviews: $e");
    return Left("Failed to fetch reviews: ${e.toString()}");
  }
}








}
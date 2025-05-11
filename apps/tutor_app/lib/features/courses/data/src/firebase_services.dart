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
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';

abstract class CourseFirebaseService {
  Future<Either<String, CourseOptionsModel>> getCourseOptions();
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, List<CoursePreview>>> getCourses({required CourseParams params});
  Future<Either<String,CourseModel>> getCourseDetails({required String courseId});
  Future<Either<String, CourseModel>> createCourse(CourseCreationReq req);
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
        price: int.parse(req.price?? "") ,
        offerPercentage: req.offerPercentage ?? 0,
        tutorId: req.tutorId ?? '',
        duration: req.duration!.inSeconds,
        isActive: false,
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
      final courseData = courseModel.toJson();
      
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
  try {
    Query query = _firestore
        .collection('courses')
        .where('tutorId', isEqualTo: params.tutorId)
        .orderBy('createdAt', descending: true)
        .limit(params.limit);

    // Add pagination logic if lastDoc is provided
    if (params.lastDoc != null) {
      query = query.startAfterDocument(params.lastDoc!);
    }

    final querySnapshot = await query.get();

    // Map the fetched documents to CoursePreview, extracting only necessary fields
    final previews = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Only extract the necessary fields to reduce overhead
      return CoursePreview(
      id: doc.id,
      isActive: data['isActive'],
      title: data['title'] ?? '',
      thumbnailUrl: data['course_thumbnail'] ?? '',
      duration: (data['duration'] ?? 0).toString(),
      rating: calculateAverageRating(data['rating_breakdown'] ?? 0),
      level: data['level']
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
    final docRef = _firestore.collection('courses').doc(courseId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return Left("Course with ID $courseId not found");
    }

    final data = docSnapshot.data()!;
    final courseModel = CourseModel.fromJson(data, docSnapshot.id);
    return Right(courseModel);
  } catch (e) {
    log("Error fetching course details: $e");
    return Left("Failed to fetch course details: ${e.toString()}");
  }
}






}
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/category_model.dart';
import 'package:user_app/features/home/data/models/courses_model.dart';
import 'package:user_app/features/home/data/models/mentor_mode.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

abstract class CoursesFirebaseService {
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, List<CoursePreview>>> getCourses();
  Future<Either<String, CourseModel>> getCourseDetails(String id);
  Future <Either<String,MentorModel>> getMentor(String mentorId);
}

class CoursesFirebaseServicesImp extends CoursesFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();

      final categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();

      log(categories.map((c) => c.title).toList().toString());

      return Right(categories);
    } catch (e) {
      log("Error fetching categories: $e");
      return Left("Failed to fetch categories: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<CoursePreview>>> getCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();

      final courses = querySnapshot.docs
          .map((doc) => CoursePreview(
            id: doc.id,
            courseTitle: doc['title'],
            thumbnail: doc['course_thumbnail'],
            averageRating:(doc['average_rating'] ?? 0).toDouble(),
            price:(doc['price'] ?? 0).toString(),
            categoryname: doc['category_name'],
          ))
          .toList();

      log(courses.map((c) => c.courseTitle).toList().toString());

      return Right(courses);
    } catch (e) {
      log("Error fetching courses: $e");
      return Left("Failed to fetch courses: ${e.toString()}");
    }
  }
  
  @override
Future<Either<String, CourseModel>> getCourseDetails(String courseId) async {
  try {

    log("call Started");
    final docSnapshot = await _firestore.collection('courses').doc(courseId).get();
    
    if (!docSnapshot.exists) {
      return Left("Course not found");
    }
    
    final courseData = docSnapshot.data()!;
    final courseModel = CourseModel.fromJson(courseData,docSnapshot.id);
    
    log("Fetched course details for: ${courseModel.title}");
    
    return Right(courseModel);
  } catch (e) {
    log("Error fetching course details: $e");
    return Left("Failed to fetch course details: ${e.toString()}");
  }
}

   @override
  Future<Either<String, MentorModel>> getMentor(String mentorId) async {
    try {
      log("call started mentorrrrr");
      final doc = await FirebaseFirestore.instance
          .collection('mentors')
          .doc(mentorId)
          .get();

      if (doc.exists && doc.data() != null) {
        final mentor = MentorModel.fromJson(doc.data()!);
        return Right(mentor);
      } else {
        return Left('Mentor not found');
      }
    } catch (e) {
      log(e.toString());
      return Left('Error fetching mentor: $e');
    }
  }
}
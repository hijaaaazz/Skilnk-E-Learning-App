import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/category_model.dart';
import 'package:user_app/features/home/data/models/courses_model.dart';

abstract class CoursesFirebaseService {
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, List<CourseModel>>> getCourses();
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
  Future<Either<String, List<CourseModel>>> getCourses() async {
    try {
      final querySnapshot = await _firestore.collection('courses').get();

      final courses = querySnapshot.docs
          .map((doc) => CourseModel.fromJson(doc.data(),doc.id))
          .toList();

      log(courses.map((c) => c.title).toList().toString());

      return Right(courses);
    } catch (e) {
      log("Error fetching courses: $e");
      return Left("Failed to fetch courses: ${e.toString()}");
    }
  }
}
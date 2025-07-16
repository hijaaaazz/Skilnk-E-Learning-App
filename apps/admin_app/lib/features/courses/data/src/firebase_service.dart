import 'package:admin_app/features/courses/data/models/category_model.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getCategories();
  Future<Either<String, CategoryModel>> addnewCategories(CategoryModel category);
  Future<Either<String, bool>> deleteCategories(String id);
  Future<Either<String, CategoryModel>> updateCategories(CategoryModel updatedCategory);
  Future<Either<String, CourseModel>> getCourseDetails(String courseId);
  Future<Either<String, List<CourseModel>>> getCourses();
  Future<Either<String, bool>> banCourse(String id);
}



class CategoryFirebaseServiceImp extends CategoryFirebaseService {
  final _categoryCollection = FirebaseFirestore.instance.collection('categories');
  final _courseCollection = FirebaseFirestore.instance.collection('courses');

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getCategories() async {
    try {
      final snapshot = await _categoryCollection.get();
      final categories = snapshot.docs.map((doc) => doc.data()).toList();
      return Right(categories);
    } catch (e) {
      return Left('Failed to fetch categories: $e');
    }
  }

  @override
  Future<Either<String, CategoryModel>> addnewCategories(CategoryModel category) async {
    try {
      final newDoc = _categoryCollection.doc();
      final newCategory = category.copyWith(
        id: newDoc.id,
        createdAt: Timestamp.now().toDate(),
        updatedAt: Timestamp.now().toDate(),
      );

      await newDoc.set(newCategory.toJson());
      return Right(newCategory);
    } catch (e) {
      return Left('Failed to add category: $e');
    }
  }

  @override
  Future<Either<String, bool>> deleteCategories(String id) async {
    try {
      final doc = await _categoryCollection.doc(id).get();
      if (!doc.exists) return Left('Category not found.');

      final data = doc.data();
      final courses = data?['courses'] ?? [];

      if (courses is List && courses.isNotEmpty) {
        return Left('Cannot delete category with assigned courses.');
      }

      await _categoryCollection.doc(id).delete();
      return Right(true);
    } catch (e) {
      return Left('Failed to delete category: $e');
    }
  }

  @override
  Future<Either<String, CategoryModel>> updateCategories(CategoryModel updatedCategory) async {
    try {
      final docRef = _categoryCollection.doc(updatedCategory.id);
      final doc = await docRef.get();
      if (!doc.exists) return Left('Category not found.');

      final updated = updatedCategory.copyWith(updatedAt: Timestamp.now().toDate());
      await docRef.update(updated.toJson());
      return Right(updated);
    } catch (e) {
      return Left('Failed to update category: $e');
    }
  }

   @override
Future<Either<String, List<CourseModel>>> getCourses() async {
  try {
    final snapshot = await _courseCollection.get();
    final courses = snapshot.docs
        .map((doc) => CourseModel.fromMap(doc.data(),doc.id)) // ✅ fix: call doc.data()
        .toList();
    return Right(courses);
  } catch (e) {
    return Left('Failed to fetch courses: $e');
  }
}


  @override
Future<Either<String, bool>> banCourse(String id) async {
  try {
    final docRef = _courseCollection.doc(id);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      return Left("Course not found");
    }

    final currentData = snapshot.data() as Map<String, dynamic>;
    final currentIsBanned = currentData['isBanned'] as bool? ?? false;

    final newIsBanned = !currentIsBanned;

    await docRef.update({'isBanned': newIsBanned});

    return Right(newIsBanned);
  } catch (e) {
    return Left('Failed to toggle ban status: $e');
  }
}


  
  @override
  Future<Either<String, CourseModel>> getCourseDetails(String courseId) {
    // TODO: implement getCourseDetails
    throw UnimplementedError();
  }
  

  
}

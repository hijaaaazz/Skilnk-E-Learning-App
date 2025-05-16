
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
abstract class CoursesRepository {
  /// Creates a new user account with email and password
  Future<Either<String, List<CategoryEntity>>> getGategories();
  Future<Either<String, List<CourseEntity>>> getCourses();
  

}
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CourseRepository {
  Future<Either<String, List<CategoryEntity>>> getCategories();
  Future<Either<String, CategoryEntity>> addNewCategories(CategoryEntity category);
  Future<Either<String, CategoryEntity>> updateCategories(CategoryEntity category);
  Future<Either<String, bool>> deleteCategories(String id);
  Future<Either<String, CourseModel>> getCourseDetails(String id);
  Future<Either<String, List<CourseModel>>> getCourses();
  Future<Either<String, bool>> bantCourse(String id);
}

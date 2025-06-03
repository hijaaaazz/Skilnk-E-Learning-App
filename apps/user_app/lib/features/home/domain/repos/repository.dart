
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
abstract class CoursesRepository {
  /// Creates a new user account with email and password
  Future<Either<String, List<CategoryEntity>>> getGategories();
  Future<Either<String, List<CoursePreview>>> getCourses();
  Future<Either<String, CourseEntity>> getCoursedetails(GetCourseDetailsParams params);
  Future<Either<String, bool>> saveCoursedetails(
    SaveCourseParams params
  );


  

}
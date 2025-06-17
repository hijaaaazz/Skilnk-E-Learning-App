import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

abstract class LibraryRepository {

  Future<Either<String,List<CoursePreview>>>getSavedCourses(String userId);
  Future<Either<String,List<CoursePreview>>>getEnrolledCourses(String userId);
  Future<Either<String,List<String>>>getSavedCoursesIds(String userId);
  Future<Either<String,List<String>>>getEnrolledCoursesIds(String userId);

}
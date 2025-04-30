
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';

abstract class CoursesRepository {
  /// Creates a new user account with email and password
  Future<Either<String, CourseEntity>> addNewCourse();

}
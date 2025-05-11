
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_options.dart';
import 'package:tutor_app/features/courses/domain/entities/language_entity.dart';

abstract class CoursesRepository {
  /// Creates a new user account with email and password
  Future<Either<String, CourseEntity>> addNewCourse(CourseCreationReq req);
  Future<Either<String,CourseOptionsModel>> getCourseOptions();
  Future<Either<String,List<CategoryEntity>>>getCategories();
  Future<Either<String,List<CourseEntity>>> getCourses();

}
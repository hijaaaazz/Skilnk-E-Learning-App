
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/data/models/toggle_params.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';

abstract class CoursesRepository {
  /// Creates a new user account with email and password
  Stream<Either<String, Either<UploadProgress,CourseEntity>>> addNewCourse(CourseCreationReq req);
  Future<Either<String,CourseOptionsModel>> getCourseOptions();
  Future<Either<String,List<CategoryEntity>>> getCategories();
  Future<Either<String,List<CoursePreview>>> getCourses({required CourseParams params});
  Future<Either<String,CourseEntity>> getCourseDetails({required String courseId});
  
Stream<Either<String, Either<UploadProgress, CourseEntity>>> updateCourse({required CourseEntity course});
  Future<Either<String, bool>> toggleActivationCourse({required courseToggleParams isactive});

  Future<Either<String,bool>> deleteCourse({required String courseId});

}
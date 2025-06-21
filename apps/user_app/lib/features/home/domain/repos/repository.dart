
import 'package:dartz/dartz.dart';
import 'package:user_app/features/course_list/data/models/load_course_params.dart';
import 'package:user_app/features/home/data/models/banner_model.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/get_progress_params.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/data/models/update_progress_params.dart';
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
  Future<Either<String,CourseProgressModel>> getProgress(
    GetCourseProgressParams params
  );

  Future<Either<String,List<CoursePreview>>> getMentorCourses(
    List<String> params
  );

  Future<Either<String,List<BannerModel>>> getBannerInfo();
   Future<Either<String,Map<String, dynamic>>> getCourseList(LoadCourseParams params);

   Future<Either<String, CourseProgressModel>> updateProgress(UpdateProgressParam params);


  

}
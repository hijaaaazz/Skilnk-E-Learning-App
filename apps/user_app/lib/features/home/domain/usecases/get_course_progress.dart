import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/home/data/models/course_progress.dart';
import  'package:user_app/features/home/data/models/get_progress_params.dart';
import  'package:user_app/features/home/data/models/lecture_progress_model.dart';
import  'package:user_app/features/home/data/src/course_progress_service.dart';
import  'package:user_app/features/home/domain/repos/repository.dart';
import  'package:user_app/service_locator.dart';

class GetCourseProgressUseCase
    implements Usecase<Either<String, CourseProgressModel>, GetCourseProgressParams> {
  
  @override
  Future<Either<String, CourseProgressModel>> call({required GetCourseProgressParams params}) async {
    try {
      final result = await serviceLocator<CoursesRepository>().getProgress(params);
      // result is already Either<String, CourseProgressModel>, just return it
      return result;
    } catch (e) {
      return Left('Failed to load course progress: ${e.toString()}');
    }
  }
}

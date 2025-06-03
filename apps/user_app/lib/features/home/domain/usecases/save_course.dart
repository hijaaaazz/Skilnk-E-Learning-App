import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class SaveCourseUseCase
    implements Usecase<Either<String, bool>, SaveCourseParams> {
  
  @override
  Future<Either<String,bool>> call({required SaveCourseParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.saveCoursedetails (params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
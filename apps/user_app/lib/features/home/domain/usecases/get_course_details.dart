import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetCourseDetailsUseCase
    implements Usecase<Either<String, CourseEntity>, GetCourseDetailsParams> {
  
  @override
  Future<Either<String,CourseEntity>> call({required GetCourseDetailsParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getCoursedetails (params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
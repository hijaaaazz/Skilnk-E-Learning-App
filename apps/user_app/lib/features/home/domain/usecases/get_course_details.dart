import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetCourseDetailsUseCase
    implements Usecase<Either<String, CourseEntity>, String> {
  
  @override
  Future<Either<String,CourseEntity>> call({required String params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getCoursedetails (params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
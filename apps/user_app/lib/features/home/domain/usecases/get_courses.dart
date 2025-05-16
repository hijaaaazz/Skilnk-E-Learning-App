import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetCoursesUseCase
    implements Usecase<Either<String, List<CourseEntity>>, NoParams> {
  
  @override
  Future<Either<String, List<CourseEntity>>> call({required NoParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getCourses ();

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
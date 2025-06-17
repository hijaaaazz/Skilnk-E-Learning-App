import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/course_list/data/models/load_course_params.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetCourseListUseCase
    implements Usecase<Either<String, Map<String,dynamic>>, LoadCourseParams> {
  
  @override
  Future<Either<String, Map<String,dynamic>>> call({required LoadCourseParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getCourseList (params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
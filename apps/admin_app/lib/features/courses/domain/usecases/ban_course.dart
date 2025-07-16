import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';


class BanCourseUsecase implements Usecase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({required String params}) async {
    return await serviceLocator<CourseRepository>().bantCourse(params);
  }
}

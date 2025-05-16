import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class DeleteCourseUseCase implements Usecase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({required String params}) async {
    final repo = serviceLocator<CoursesRepository>();
    return await repo.deleteCourse(courseId:  params);
  }
}

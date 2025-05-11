import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class GetCourseDetailUseCase implements Usecase<Either<String, CourseEntity>, String> {
  @override
  Future<Either<String, CourseEntity>> call({required String params}) async {
    final repo = serviceLocator<CoursesRepository>();
    return await repo.getCourseDetails(courseId: params);
  }
}

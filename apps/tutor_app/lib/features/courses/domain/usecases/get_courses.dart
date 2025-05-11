import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/domain/entities/course_options.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';
class GetCoursesUseCase
    implements Usecase<Either<String, List<CoursePreview>>, CourseParams> {
  
  @override
  Future<Either<String, List<CoursePreview>>> call({required CourseParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getCourses (params:  params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}

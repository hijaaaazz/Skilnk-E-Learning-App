import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetMentorCoursesUseCase
    implements Usecase<Either<String, List<CoursePreview>>, List<String>> {
  
  @override
  Future<Either<String, List<CoursePreview>>> call({required params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getMentorCourses(params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) {
        log("Mentor Courses: ${r.map((t) => t.id).toList()}");
        return Right(r);
      },
    );
  }
}

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';


class UpdateCourseUseCase
    implements Usecase<Either<String, CourseEntity>, CourseEntity> {
  @override
  Future<Either<String, CourseEntity>> call({required CourseEntity params}) async {
    log('update course started');
    final stream = serviceLocator<CoursesRepository>().updateCourse(course: params);

    await for (final event in stream) {
      if (event.isRight()) {
        final inner = event.getOrElse(() => throw Exception('Unexpected null'));

        if (inner is Right<UploadProgress, CourseEntity>) {
          final courseEntity = inner.getOrElse(() => throw Exception('No course found'));
          return Right(courseEntity);
        }
      } else {
        return Left(event.fold((l) => l, (_) => 'Unknown error'));
      }
    }

    return Left('No final CourseEntity found');
  }
}

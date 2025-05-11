
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class CreateCourseUseCase
    implements StreamUsecase<Either<String, Either<UploadProgress, CourseEntity>>, CourseCreationReq> {

  @override
  Stream<Either<String, Either<UploadProgress, CourseEntity>>> call({required CourseCreationReq params}) {
    log('add new course started');
    return serviceLocator<CoursesRepository>().addNewCourse(params);
  }
}

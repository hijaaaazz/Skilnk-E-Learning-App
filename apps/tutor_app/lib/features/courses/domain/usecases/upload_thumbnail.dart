
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/common/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class UploadThumbnailUseCase implements Usecase<Either<String, CourseEntity>, NoParams> {
  @override
  Future<Either<String, CourseEntity>> call({ required params}) {
    log('ad new course started');
    return serviceLocator<CoursesRepository>().addNewCourse();
  }
}
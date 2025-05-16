import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/toggle_params.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class ToggleCourseUseCase implements Usecase<Either<String, bool>,courseToggleParams> {
  @override
  Future<Either<String, bool>> call({required courseToggleParams params}) async {
    log('update course started');

    final result = await serviceLocator<CoursesRepository>()
        .toggleActivationCourse(isactive: params);

    return result;
  }
}

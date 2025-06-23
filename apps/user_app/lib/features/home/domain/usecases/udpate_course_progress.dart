import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/update_progress_params.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class UpdateProgressUseCase
    implements Usecase<Either<String,CourseProgressModel>, UpdateProgressParam> {
  
  @override
  Future<Either<String, CourseProgressModel>> call({required UpdateProgressParam params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final progressResult = await repo.updateProgress (params);
  log(progressResult.toString());
  log("usecase called!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1");
    return progressResult.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
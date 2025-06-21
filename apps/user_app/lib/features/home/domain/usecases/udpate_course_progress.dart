import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/update_progress_params.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/domain/repos/mentors_repo.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class UpdateProgressUseCase
    implements Usecase<Either<String,CourseProgressModel>, UpdateProgressParam> {
  
  @override
  Future<Either<String, CourseProgressModel>> call({required UpdateProgressParam params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final progressResult = await repo.updateProgress (params);

    return progressResult.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/domain/repos/mentors_repo.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetMentorsUseCase
    implements Usecase<Either<String, List<MentorEntity>>, NoParams> {
  
  @override
  Future<Either<String, List<MentorEntity>>> call({required NoParams params}) async {
    final repo = serviceLocator<MentorsRepo>();

    final coursePreviews = await repo.getMentors ();

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}
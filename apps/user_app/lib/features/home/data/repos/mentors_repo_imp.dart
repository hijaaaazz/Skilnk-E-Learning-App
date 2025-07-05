import 'dart:math';

import 'package:dartz/dartz.dart';
import  'package:user_app/features/home/data/src/firebase_service.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';
import  'package:user_app/features/home/domain/repos/mentors_repo.dart';
import  'package:user_app/service_locator.dart';

class MentorsRepoImp extends MentorsRepo {
  @override
  Future<Either<String, List<MentorEntity>>> getMentors() async{
    final result =
        await serviceLocator<CoursesFirebaseService>().getMentors();

    return result.fold(
      (l) => Left(l),
      (courseData)=> Right(courseData)
    );
  }

}
import 'dart:developer';

import 'package:admin_app/features/instructors/data/models/mentor_model.dart';
import 'package:admin_app/features/instructors/data/src/mentors_firebase_service.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/domain/repos/mentor_managment.dart';
import 'package:admin_app/features/users/data/src/users_firebase_service.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class MentorsRepoImp extends MentorsRepo {
  @override
  Future<Either<String, List<MentorEntity>>> getUsers() async {
    var users = await serviceLocator<MentorsFirebaseService>().getUsers();

    return users.fold(
      (error) {
        return left(error);
      },
      (data) {
        log("converted to entity");

        List<MentorEntity> userEntities = data
            .map((userMap) {
              MentorModel userModel = MentorModel.fromMap(userMap);
              return userModel.toEntity();
            })
            .toList();

        return Right(userEntities);
      },
    );
  }
}

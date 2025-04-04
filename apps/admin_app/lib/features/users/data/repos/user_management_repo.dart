import 'dart:developer';

import 'package:admin_app/features/users/data/models/user_model.dart';
import 'package:admin_app/features/users/data/src/users_firebase_service.dart';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/domain/repos/user_managment.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class UsersRepoImp extends UsersRepo {
  @override
  Future<Either<String, List<UserEntity>>> getUsers() async {
    var users = await serviceLocator<UsersFirebaseService>().getUsers();

    return users.fold(
      (error) {
        return left(error);
      },
      (data) {
        log("converted to entity");

        List<UserEntity> userEntities = data
            .map((userMap) {
              UserModel userModel = UserModel.fromMap(userMap);
              return userModel.toEntity();
            })
            .toList();

        return Right(userEntities);
      },
    );
  }
}

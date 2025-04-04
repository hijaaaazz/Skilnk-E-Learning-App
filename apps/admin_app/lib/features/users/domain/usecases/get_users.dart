import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/users/domain/repos/user_managment.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class GetUsersUseCase implements Usecase<Either, dynamic> {  // Use nullable type
  @override
  Future<Either> call({ dynamic params}) async {  // Optional params
   
    try {
      Either response =
          await serviceLocator<UsersRepo>().getUsers();

          log("got the responce");
      return response;
    } catch (e) {
      log("$e");
      return Left("Signup failed: $e");
    }
  }
}

// SignupUseCase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/domain/auth/entity/user.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class SignupUseCase implements Usecase<Either<String, dynamic>, UserCreationReq> {
  @override
  Future<Either<String, UserEntity>> call({required UserCreationReq params}) async {
    return await serviceLocator<AuthRepository>().signUp(params);
  }
}



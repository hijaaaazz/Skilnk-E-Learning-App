

// CheckVerificationUseCase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/entity/user.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';


class CheckVerificationUseCase implements Usecase<Either<String, bool>, UserEntity> {
  @override
  Future<Either<String, bool>> call({required UserEntity params}) {
    log('checkEmailVerified started');
    return serviceLocator<AuthRepository>().isEmailVerified(params);
  }
}


// CheckVerificationUseCase.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';


class CheckVerificationUseCase implements Usecase<Either<String, bool>, UserEntity> {
  @override
  Future<Either<String, bool>> call({required UserEntity params}) {
    log('checkEmailVerified started');
    return serviceLocator<AuthRepository>().isEmailVerified(params);
  }
}
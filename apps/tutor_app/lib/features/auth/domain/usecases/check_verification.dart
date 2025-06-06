import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class CheckVerificationUseCase
    implements StreamUsecase<Either<String, bool>, UserEntity> {
  @override
  Stream<Either<String, bool>> call({required UserEntity params}) async* {
    while (true) {
      log('Checking email verification for user: ${params.tutorId}');

      final result = await serviceLocator<AuthRepository>()
          .isEmailVerified(params);

      log('Email verification result: $result');

      yield result;

      // Stop checking if verified
      if (result.isRight() && result.getOrElse(() => false)) {
        log('User email verified, stopping stream.');
        break;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}

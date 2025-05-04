

// CheckVerificationByAdminUseCase.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class CheckVerificationByAdminUseCase
    implements StreamUsecase<Either<String, bool>, UserEntity> {
 

  @override
  Stream<Either<String, bool>> call({required UserEntity params}) async* {
    while (true) {
      log('Checking verification for user: ${params.tutorId}'); // Log to check the params

      final result = await serviceLocator<AuthRepository>()
          .checkIfUserVerifiedByAdmin(params);

      log('Verification result: $result'); // Log the result

      yield result;

      // Break the loop if verification is successful
      if (result.isRight() && result.getOrElse(() => false)) {
        log('User verified, stopping verification check.');
        break;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}

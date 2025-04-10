

// CheckVerificationUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class CheckVerificationUseCase implements Usecase<Either<String, bool>, NoParams> {
  @override
  Future<Either<String, bool>> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().isEmailVerified();
  }
}
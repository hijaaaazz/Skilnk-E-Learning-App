

// ResendVerificationEmailUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class ResendVerificationEmailUseCase implements Usecase<Either<String, String>, NoParams> {
  @override
  Future<Either<String, String>> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().sendEmailVerification();
  }
}

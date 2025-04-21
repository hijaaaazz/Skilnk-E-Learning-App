
// ResetPasswordUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class ResetPasswordUseCase implements Usecase<Either<String, String>, String> {
  @override
  Future<Either<String, String>> call({required String params}) {
    return serviceLocator<AuthRepository>().sendPasswordResetEmail(params);
  }
}
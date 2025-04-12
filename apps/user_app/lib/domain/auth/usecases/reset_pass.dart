
// ResetPasswordUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';
class ResetPasswordUseCase implements Usecase<Either<String, String>, String> {
  @override
  Future<Either<String, String>> call({required String params}) {
    return serviceLocator<AuthRepository>().sendPasswordResetEmail(params);
  }
}

// LogoutUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';
class LogOutUseCase implements Usecase<Either<String, String>, NoParams> {
  @override
  Future<Either<String, String>> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().logOut();
  }
}

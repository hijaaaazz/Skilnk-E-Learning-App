import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/domain/auth/entity/user.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class RegisterUserUseCase implements Usecase<Either<String, UserEntity>, UserEntity> {
  @override
  Future<Either<String, UserEntity>> call({required UserEntity params}) async {
    return await serviceLocator<AuthRepository>().registerUser(params);
  }
}

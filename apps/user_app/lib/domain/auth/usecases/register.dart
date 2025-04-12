import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/data/auth/models/user_model.dart';
import 'package:user_app/domain/auth/entity/user.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';

class RegisterUserUseCase implements Usecase<Either<String, UserEntity>, UserEntity> {
  @override
  Future<Either<String, UserEntity>> call({required UserEntity params}) async {
    return await serviceLocator<AuthRepository>().registerUser(params);
  }
}

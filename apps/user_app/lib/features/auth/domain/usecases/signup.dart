// SignupUseCase.dart
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/auth/data/models/user_creation_req.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';

class SignupUseCase implements Usecase<Either<String, dynamic>, UserCreationReq> {
  @override
  Future<Either<String, UserEntity>> call({required UserCreationReq params}) async {
    return await serviceLocator<AuthRepository>().signUp(params);
  }
}



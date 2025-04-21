import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/auth/data/models/user_signin_model.dart';
import 'package:user_app/features/auth/domain/entity/user.dart';
import 'package:user_app/features/auth/domain/repository/auth.dart';
import 'package:user_app/service_locator.dart';

class SignInUseCase implements Usecase<Either<String, UserEntity>, UserSignInReq> {
  @override
  Future<Either<String, UserEntity>> call({required UserSignInReq params}) async {
    
    return await serviceLocator<AuthRepository>().signIn(params);
    
  }
}
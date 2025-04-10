import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';


class SignInWithGoogle implements Usecase<Either, NoParams> {
  @override
  Future<Either> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().signInWithGoogle();
  }
  
}

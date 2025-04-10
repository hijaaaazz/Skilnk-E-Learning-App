import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';


class SignInusecase implements Usecase<Either, UserSignInReq> {
  @override
  Future<Either> call({UserSignInReq? params}) {
    return serviceLocator<AuthRepository>().signIn(params!);
  }
  
}

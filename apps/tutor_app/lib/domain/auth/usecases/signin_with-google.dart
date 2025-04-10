import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';


class SignInWithGoogleUseCase implements Usecase<Either, NoParams> {
  @override
  Future<Either> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().signInWithGoogleUseCase();
  }
  
}

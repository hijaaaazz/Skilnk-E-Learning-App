
// SignInWithGoogleUseCase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';

class SignInWithGoogleUseCase implements Usecase<Either<String, UserEntity>, NoParams> {
  @override
  Future<Either<String, UserEntity>> call({NoParams? params}) {
    log("Google sign-in process initiated");
    return serviceLocator<AuthRepository>().signInWithGoogle();
  }
}
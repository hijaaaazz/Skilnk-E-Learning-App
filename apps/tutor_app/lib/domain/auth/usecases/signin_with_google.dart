
// SignInWithGoogleUseCase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class SignInWithGoogleUseCase implements Usecase<Either<String, UserModel>, NoParams> {
  @override
  Future<Either<String, UserModel>> call({NoParams? params}) {
    log("Google sign-in process initiated");
    return serviceLocator<AuthRepository>().signInWithGoogle();
  }
}
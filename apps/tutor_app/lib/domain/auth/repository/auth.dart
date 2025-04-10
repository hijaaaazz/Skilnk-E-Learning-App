import 'package:dartz/dartz.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';

abstract class AuthRepository{

  Future<Either> signUp(
    UserCreationReq user
  );

  Future<Either> signIn(
    UserSignInReq user
  );

  Future<Either> signInWithGoogleUseCase();

  Future<Either> logOut();

  Future<Either> getCurrentUser();
}
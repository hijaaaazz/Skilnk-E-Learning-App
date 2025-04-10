import 'package:dartz/dartz.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/data/auth/models/user_signin_model.dart';

abstract class AuthRepository{

  Future<Either> signUp(
    UserCreationReq user
  );

  Future<Either> signIn(
    UserSignInReq user
  );

  Future<Either> signInWithGoogle();

  Future<Either> logOut();

  Future<Either> getCurrentUser();
}
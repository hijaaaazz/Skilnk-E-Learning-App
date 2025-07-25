import 'package:dartz/dartz.dart';
import 'package:user_app/features/auth/data/models/user_creation_req.dart';

abstract class AuthRepository{

  Future<Either> signUp(
    UserCreationReq user
  );

}
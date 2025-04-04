import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository{

  Future<Either> signUp(
    AdminSignInReq user
  );

}
import 'package:dartz/dartz.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/repository/auth.dart';

class AuthenticationRepoImplementation extends AuthRepository{

  
  @override
  Future<Either> signUp(UserCreationReq user) {
    // TODO: implement signUp
    throw UnimplementedError();
  }



}
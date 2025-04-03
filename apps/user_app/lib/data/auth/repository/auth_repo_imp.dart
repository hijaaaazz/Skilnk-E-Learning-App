import 'package:dartz/dartz.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/data/auth/src/auth_firebase_service.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository{

  
  @override
  Future<Either> signUp(UserCreationReq user) async {
    return await serviceLocator<AuthFirebaseService>().signUp(user); 
  }



}
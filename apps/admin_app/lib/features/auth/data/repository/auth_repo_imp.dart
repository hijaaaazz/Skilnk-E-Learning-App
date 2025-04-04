

import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:admin_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:admin_app/features/auth/domain/repository/auth.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepoImplementation extends AuthRepository{

  
  @override
  Future<Either> signUp(AdminSignInReq user) async {
    return await serviceLocator<AuthFirebaseService>().signIn(user); 
  }



}
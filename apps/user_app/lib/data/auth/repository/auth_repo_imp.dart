import 'package:dartz/dartz.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/data/auth/models/user_signin_model.dart';
import 'package:user_app/data/auth/src/auth_firebase_service.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository{

  
  @override
  Future<Either> signUp(UserCreationReq user) async {
    return await serviceLocator<AuthFirebaseService>().signUp(user); 
  }
  
  @override
  Future<Either> signIn(UserSignInReq user) async {
    return await serviceLocator<AuthFirebaseService>().signIn(user);
  }
  
  @override
  Future<Either> signInWithGoogle() async {
    return await serviceLocator<AuthFirebaseService>().signInWithGoogle();
  }
  
  @override
  Future<Either> logOut() async {
    return await serviceLocator<AuthFirebaseService>().logout();
  }
  
  @override
Future<Either> getCurrentUser() async {
  final result = await serviceLocator<AuthFirebaseService>().getCurrentUser();

  return result.fold(
    (failure) => Left(failure),
    (model) => Right(model.toEntity()), 
  );
}




}
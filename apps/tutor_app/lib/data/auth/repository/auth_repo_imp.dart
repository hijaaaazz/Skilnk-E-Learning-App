import 'package:dartz/dartz.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/data/auth/src/auth_firebase_service.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository {
  
  @override
  Future<Either> signUp(UserCreationReq user) async {
    try {
      final result = await serviceLocator<AuthFirebaseService>().signUp(user);
      return result.fold(
        (error){
          return Left(error);
        },(userModel){
          return Right(userModel.toEntity());
        });
    } catch (e, stacktrace) {
      print('signUp error: $e\n$stacktrace');
      return Left(Exception('Signup failed'));
    }
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    try {
      return await serviceLocator<AuthFirebaseService>().signIn(user);
    } catch (e, stacktrace) {
      print('signIn error: $e\n$stacktrace');
      return Left(Exception('Signin failed'));
    }
  }

  @override
  Future<Either> signInWithGoogleUseCase() async {
    try {
      return await serviceLocator<AuthFirebaseService>().signInWithGoogleUseCase();
    } catch (e, stacktrace) {
      print('SignInWithGoogleUseCase error: $e\n$stacktrace');
      return Left(Exception('Google sign-in failed'));
    }
  }

  @override
  Future<Either> logOut() async {
    try {
      return await serviceLocator<AuthFirebaseService>().logout();
    } catch (e, stacktrace) {
      print('logout error: $e\n$stacktrace');
      return Left(Exception('Logout failed'));
    }
  }

  @override
  Future<Either> getCurrentUser() async {
    try {
      final result = await serviceLocator<AuthFirebaseService>().getCurrentUser();
      return result.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } catch (e, stacktrace) {
      print('getCurrentUser error: $e\n$stacktrace');
      return Left(Exception('Failed to get current user'));
    }
  }
}

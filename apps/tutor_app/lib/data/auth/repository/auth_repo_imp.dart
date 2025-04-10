import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/data/auth/src/auth_firebase_service.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository {
  @override
  Future<Either<String, dynamic>> signUp(UserCreationReq user) async {
    try {
      final result = await serviceLocator<AuthFirebaseService>().signUp(user);
      return result.fold(
        (error) {
          log("Signup error: $error");
          return Left(error);
        },
        (success) {
          log("Signup success: $success");
          return Right(success);
        }
      );
    } catch (e, stacktrace) {
      log('signUp unexpected error: $e\n$stacktrace');
      return Left('Signup failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserModel>> signIn(UserSignInReq user) async {
    try {
      return await serviceLocator<AuthFirebaseService>().signIn(user);
    } catch (e, stacktrace) {
      log('signIn unexpected error: $e\n$stacktrace');
      return Left('Signin failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserModel>> signInWithGoogle() async {
    try {
      return await serviceLocator<AuthFirebaseService>().signInWithGoogle();
    } catch (e, stacktrace) {
      log('SignInWithGoogle unexpected error: $e\n$stacktrace');
      return Left('Google sign-in failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, String>> logOut() async {
    try {
      return await serviceLocator<AuthFirebaseService>().logout();
    } catch (e, stacktrace) {
      log('logout unexpected error: $e\n$stacktrace');
      return Left('Logout failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUser() async {
    try {
      return await serviceLocator<AuthFirebaseService>().getCurrentUser();
    } catch (e, stacktrace) {
      log('getCurrentUser unexpected error: $e\n$stacktrace');
      return Left('Failed to get current user due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, String>> sendEmailVerification() async {
    try {
      return await serviceLocator<AuthFirebaseService>().sendEmailVerification();
    } catch (e, stacktrace) {
      log('sendEmailVerification unexpected error: $e\n$stacktrace');
      return Left('Failed to send email verification due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, String>> registerUser(UserCreationReq user) async {
    try {
      return await serviceLocator<AuthFirebaseService>().registerUser(user);
    } catch (e, stacktrace) {
      log('registerUser unexpected error: $e\n$stacktrace');
      return Left('Failed to register user due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      return await serviceLocator<AuthFirebaseService>().sendPasswordResetEmail(email);
    } catch (e, stacktrace) {
      log('sendPasswordResetEmail unexpected error: $e\n$stacktrace');
      return Left('Failed to send password reset email due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, bool>> isEmailVerified() async {
    try {
      return await serviceLocator<AuthFirebaseService>().isEmailVerified();
    } catch (e, stacktrace) {
      log('isEmailVerified unexpected error: $e\n$stacktrace');
      return Left('Failed to check email verification status due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, bool>> checkIfUserExists(String email) async {
    try {
      return await serviceLocator<AuthFirebaseService>().checkIfUserExists(email);
    } catch (e, stacktrace) {
      log('checkIfUserExists unexpected error: $e\n$stacktrace');
      return Left('Failed to check if user exists due to an unexpected error');
    }
  }
}
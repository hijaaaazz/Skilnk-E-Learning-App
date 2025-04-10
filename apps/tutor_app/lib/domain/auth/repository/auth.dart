import 'package:dartz/dartz.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';

abstract class AuthRepository {
  /// Creates a new user account with email and password
  Future<Either<String, dynamic>> signUp(UserCreationReq user);

  /// Registers additional user information in Firestore after signup
  Future<Either<String, String>> registerUser(UserCreationReq user);

  /// Signs in an existing user with email and password
  Future<Either<String, UserModel>> signIn(UserSignInReq user);

  /// Signs in using Google authentication
  Future<Either<String, UserModel>> signInWithGoogle();

  /// Logs out the current user
  Future<Either<String, String>> logOut();

  /// Gets the currently logged in user
  Future<Either<String, UserModel>> getCurrentUser();

  /// Sends an email verification to the current user
  Future<Either<String, String>> sendEmailVerification();
  
  /// Sends a password reset email to the specified email address
  Future<Either<String, String>> sendPasswordResetEmail(String email);
  
  /// Checks if the current user's email is verified
  Future<Either<String, bool>> isEmailVerified();
  
  /// Checks if a user with the given email exists
  Future<Either<String, bool>> checkIfUserExists(String email);
}
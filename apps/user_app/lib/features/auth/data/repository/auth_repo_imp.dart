import 'dart:developer';
import 'package:dartz/dartz.dart';
import  'package:user_app/features/auth/data/models/user_creation_req.dart';
import  'package:user_app/features/auth/data/models/user_model.dart';
import  'package:user_app/features/auth/data/models/user_signin_model.dart';
import  'package:user_app/features/auth/data/src/auth_firebase_service.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository {
  final AuthFirebaseService _authService = serviceLocator<AuthFirebaseService>();

  @override
  Future<Either<String, UserEntity>> signUp(UserCreationReq user) async {
    try {
      // Validation logic moved from service to repo
      if (user.email?.isEmpty ?? true) return Left("Email cannot be empty");
      if (user.password?.isEmpty ?? true) return Left("Password cannot be empty");
      if (user.password!.length < 6) return Left("Password must be at least 6 characters");

      final email = user.email!;
      final password = user.password!;

      // Create user with Firebase Auth
      final credentialResult = await _authService.createUserWithEmailPassword(email, password);
      
      return credentialResult.fold(
        (error) {
          if (error.contains('email-already-in-use')) {
            return Left("Email already registered. Please login.");
          }
          return Left("Auth error: $error");
        },
        (credential) async {
          final firebaseUser = credential.user!;
          
          // Update display name if provided
          if (user.name?.isNotEmpty ?? false) {
            await _authService.updateDisplayName(firebaseUser.uid, user.name!);
          }

          // Send email verification
          await _authService.sendEmailVerification();

          // Create user model
          final userModel = UserModel(
            userId: firebaseUser.uid,
            email: email,
            name: user.name ?? '',
            image: firebaseUser.photoURL ?? '',
            emailVerified: false,
            createdDate: DateTime.now(),
            savedCourses: []
          );

          // Save to Firestore
          final saveResult = await _authService.saveUserToFirestore(userModel);
          
          return saveResult.fold(
            (error) => Left(error),
            (_) => Right(userModel.toEntity())
          );
        }
      );
    } catch (e, stacktrace) {
      log('signUp unexpected error: $e\n$stacktrace');
      return Left('Signup failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserEntity>> signIn(UserSignInReq user) async {
    try {
      // Validation logic moved to repo
      if (user.email?.isEmpty ?? true) return Left("Email required");
      if (user.password?.isEmpty ?? true) return Left("Password required");

      final email = user.email!;

      // Check if user is in restricted collections
      final restrictedResult = await _authService.checkInRestrictedCollections(email);
      
      return restrictedResult.fold(
        (error) => Left(error),
        (isRestricted) async {
          if (isRestricted) {
            return Left("You are not allowed to login from User app");
          }

          // Firebase Sign In
          final signInResult = await _authService.loginWithEmailPassword(email, user.password!);
          
          return signInResult.fold(
            (error) {
              if (error.contains('user-not-found')) {
                return Left("No account found");
              } else if (error.contains('wrong-password') || error.contains('invalid-credential')) {
                return Left("Incorrect password");
              }
              return Left("Login failed: $error");
            },
            (credential) async {
              final firebaseUser = credential.user!;
              
              // Check email verification
              final verifiedResult = await _authService.isEmailVerified();
              
              return verifiedResult.fold(
                (error) => Left(error),
                (isVerified) async {
                  // Create basic user model
                  final userModel = UserModel(
                    userId: firebaseUser.uid,
                    email: firebaseUser.email ?? '',
                    name: firebaseUser.displayName ?? '',
                    image: firebaseUser.photoURL ?? '',
                    emailVerified: isVerified,
                    createdDate: DateTime.now(),
                    savedCourses: []
                  );
                  
                  // If not verified, send verification email and return basic model
                  if (!isVerified) {
                    await _authService.sendEmailVerification();
                    return Right(userModel.toEntity());
                  }
                  
                  // Get user data from Firestore
                  final userDataResult = await _authService.getUserData(firebaseUser.uid);
                  
                  return userDataResult.fold(
                    (error) => Left(error),
                    (userData) {
                      if (userData == null) {
                        return Left("User profile not found");
                      }
                      return Right(UserModel.fromJson(userData).toEntity());
                    }
                  );
                }
              );
            }
          );
        }
      );
    } catch (e, stacktrace) {
      log('signIn unexpected error: $e\n$stacktrace');
      return Left('Signin failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() async {
    try {
      final googleSignInResult = await _authService.signInWithGoogle();
      
      return googleSignInResult.fold(
        (error) => Left(error),
        (firebaseUser) async {
          if (firebaseUser == null) {
            return Left("Google sign in cancelled");
          }

          final email = firebaseUser.email ?? '';
          
          // Check if user is in restricted collections
          final restrictedResult = await _authService.checkInRestrictedCollections(email);
          
          return restrictedResult.fold(
            (error) => Left(error),
            (isRestricted) async {
              if (isRestricted) {
                await _authService.logout();
                return Left("You are not allowed to login from User app");
              }
              
              // Create user model
              final userModel = UserModel(
                userId: firebaseUser.uid,
                email: email,
                name: firebaseUser.displayName ?? 'User',
                image: firebaseUser.photoURL ?? '',
                emailVerified: true,
                createdDate: DateTime.now(),
                savedCourses: []
              );
              
              // Save to Firestore
              final saveResult = await _authService.saveUserToFirestore(userModel);
              
              return saveResult.fold(
                (error) => Left(error),
                (_) => Right(userModel.toEntity())
              );
            }
          );
        }
      );
    } catch (e, stacktrace) {
      log('SignInWithGoogle unexpected error: $e\n$stacktrace');
      return Left('Google sign-in failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, String>> logOut() async {
    try {
      return await _authService.logout();
    } catch (e, stacktrace) {
      log('logout unexpected error: $e\n$stacktrace');
      return Left('Logout failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUser() async {
    try {
      final userResult = await _authService.getCurrentFirebaseUser();
      
      return userResult.fold(
        (error) => Left(error),
        (firebaseUser) async {
          if (firebaseUser == null) {
            return Left('No logged-in user');
          }
          
          if (!firebaseUser.emailVerified) {
            return Left('Email not verified');
          }
          
          final userDataResult = await _authService.getUserData(firebaseUser.uid);
          
          return userDataResult.fold(
            (error) => Left(error),
            (userData) {
              if (userData == null) {
                return Left('User profile not found');
              }
              return Right(UserModel.fromJson(userData));
            }
          );
        }
      );
    } catch (e, stacktrace) {
      log('getCurrentUser unexpected error: $e\n$stacktrace');
      return Left('Failed to get current user due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, String>> sendEmailVerification() async {
    try {
      final userResult = await _authService.getCurrentFirebaseUser();
      
      return userResult.fold(
        (error) => Left(error),
        (firebaseUser) async {
          if (firebaseUser == null) {
            return Left('No user signed in');
          }
          
          if (firebaseUser.emailVerified) {
            return Right('Email already verified');
          }
          
          return await _authService.sendEmailVerification();
        }
      );
    } catch (e, stacktrace) {
      log('sendEmailVerification unexpected error: $e\n$stacktrace');
      return Left('Failed to send email verification due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, UserEntity>> registerUser(UserEntity user) async {
    try {
      final userResult = await _authService.getCurrentFirebaseUser();
      
      return userResult.fold(
        (error) => Left(error),
        (firebaseUser) async {
          if (firebaseUser == null) {
            return Left("No authenticated user");
          }
          
          if (!firebaseUser.emailVerified) {
            return Left("Email not verified");
          }
          
          final userModel = UserModel.fromEntity(user);
          final updateduser = userModel.copyWith(emailVerified: true);
          
          // Save to Firestore
          final saveResult = await _authService.saveUserToFirestore(updateduser);
          
          return saveResult.fold(
            (error) => Left(error),
            (_) => Right(userModel.toEntity())
          );
        }
      );
    } catch (e, stacktrace) {
      log('registerUser unexpected error: $e\n$stacktrace');
      return Left('Failed to register user due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        return Left('Email required');
      }
      
      log(email);
      return await _authService.sendPasswordResetEmail(email);
    } catch (e, stacktrace) {
      log('sendPasswordResetEmail unexpected error: $e\n$stacktrace');
      return Left('Failed to send password reset email due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, bool>> checkIfUserExists(String email) async {
    try {
      final methodsResult = await _authService.fetchSignInMethodsForEmail(email);
      
      return methodsResult.fold(
        (error) => Left(error),
        (methods) {
          log(methods.toString());
          return Right(methods.isNotEmpty);
        }
      );
    } catch (e, stacktrace) {
      log('checkIfUserExists unexpected error: $e\n$stacktrace');
      return Left('Failed to check if user exists due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, bool>> isEmailVerified(UserEntity user) async {
    try {
      final verifiedResult = await _authService.isEmailVerified();
      
      return verifiedResult.fold(
        (error) => Left(error),
        (isVerified) async {
          if (isVerified) {
            // Register user if email is verified
            await registerUser(user);
          }
          
          return Right(isVerified);
        }
      );
    } catch (e, stacktrace) {
      log('isEmailVerified unexpected error: $e\n$stacktrace');
      return Left('Failed to check isEmailVerified');
    }
  }
}
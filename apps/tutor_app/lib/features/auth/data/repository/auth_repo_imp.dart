import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutor_app/features/auth/data/models/user_creation_req.dart';
import 'package:tutor_app/features/auth/data/models/user_model.dart';
import 'package:tutor_app/features/auth/data/models/user_signin_model.dart';
import 'package:tutor_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class AuthenticationRepoImplementation extends AuthRepository {
  final AuthFirebaseService _firebaseService = serviceLocator<AuthFirebaseService>();

  @override
  Future<Either<String, UserEntity>> signUp(UserCreationReq user) async {
    try {
      // Validate user input
      if (user.email?.isEmpty ?? true) return Left("Email cannot be empty");
      if (user.password?.isEmpty ?? true) return Left("Password cannot be empty");
      if (user.password!.length < 6) return Left("Password must be at least 6 characters");

      // Create user with Firebase Auth
      final UserCredential credential;
      try {
        credential = await _firebaseService.createUserWithEmailPassword(
          user.email!,
          user.password!,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          return Left("Email already registered. Please login.");
        }
        return Left("Auth error: ${e.message}");
      }

      final firebaseUser = credential.user!;

      // Update display name if provided
      if (user.name?.isNotEmpty ?? false) {
        await _firebaseService.updateUserDisplayName(user.name!);
      }

      // Send email verification
      await _firebaseService.sendVerificationEmail();

      // Create user model
      final userModel = UserModel(
        tutorId: firebaseUser.uid,
        name: user.name ?? '',
        email: firebaseUser.email ?? '',
        image: firebaseUser.photoURL ?? '',
        emailVerified: false,
        infoSubmitted: false,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
      );

      // Save user to Firestore
      await _firebaseService.saveUserToFirestore(userModel);

      // Get the saved user with server timestamp
      final savedUser = await _firebaseService.getUserFromFirestore(firebaseUser.uid);
      if (savedUser == null) {
        return Left("Failed to retrieve user data after signup.");
      }

      return Right(savedUser.toEntity());
    } catch (e, stacktrace) {
      log('signUp unexpected error: $e\n$stacktrace');
      return Left('Signup failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserEntity>> signIn(UserSignInReq user) async {
    try {
      log('Sign In Auth call started');

      if (user.email?.isEmpty ?? true) return Left("Email required");
      if (user.password?.isEmpty ?? true) return Left("Password required");

      // Sign in with Firebase
      final UserCredential authResult;
      try {
        authResult = await _firebaseService.signInWithEmailPassword(
          user.email!,
          user.password!,
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'user-not-found':
            return Left("No account found");
          case 'wrong-password':
          case 'invalid-credential':
            return Left("Incorrect password");
          default:
            return Left("Login failed: ${e.message}");
        }
      }

      final firebaseUser = authResult.user!;
      
      // Check if user exists in other collections (not allowed to login)
      final isUserInUsersCollection = await _firebaseService.checkUserCollectionForEmail(
        user.email!,
        'users',
      );
      
      
      final isUserInAdminsCollection = await _firebaseService.checkUserCollectionForEmail(
        user.email!,
        'admins',
      );

      if (isUserInUsersCollection || isUserInAdminsCollection) {
        await _firebaseService.signOutUser();
        return Left("You are not allowed to login from Tutor app");
      }

      // Check email verification
      if (!firebaseUser.emailVerified) {
        await _firebaseService.sendVerificationEmail();
        return Left("Email not verified. A verification email has been sent.");
      }

      // Get full user data from Firestore
      final userModel = await _firebaseService.getUserFromFirestore(firebaseUser.uid);
      if (userModel == null) {
        return Left("No user data found in Firestore.");
      }

      log("Login successful, user data: ${userModel.toJson()}");
      return Right(userModel.toEntity());
    } catch (e, stacktrace) {
      log('signIn unexpected error: $e\n$stacktrace');
      return Left('Signin failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() async {
    try {
      // Authenticate with Google
      final UserCredential? authResult = await _firebaseService.authenticateWithGoogle();
      if (authResult == null) {
        return Left("Google sign in cancelled");
      }

      final firebaseUser = authResult.user;
      if (firebaseUser == null) {
        return Left("Google authentication failed");
      }

      final email = firebaseUser.email ?? '';

      // Check if user exists in other collections (not allowed to login)
      final isUserInUsersCollection = await _firebaseService.checkUserCollectionForEmail(
        email,
        'users',
      );
      
      final isUserInAdminsCollection = await _firebaseService.checkUserCollectionForEmail(
        email,
        'admins',
      );

      if (isUserInUsersCollection || isUserInAdminsCollection) {
        await _firebaseService.signOutUser();
        log('no entry');
        return Left("You are not allowed to login from Tutor app");
      }

      // Check if user exists in mentors collection
      UserModel? userModel = await _firebaseService.getUserFromFirestore(firebaseUser.uid);

      if (userModel == null) {
        // First-time login - create new mentor document
        userModel = UserModel(
          tutorId: firebaseUser.uid,
          email: email,
          name: firebaseUser.displayName ?? 'User',
          image: firebaseUser.photoURL ?? '',
          emailVerified: firebaseUser.emailVerified,
          infoSubmitted: false,
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
        );

        await _firebaseService.saveUserToFirestore(userModel);
      }

      return Right(userModel.toEntity());
    } catch (e, stacktrace) {
      log('SignInWithGoogle unexpected error: $e\n$stacktrace');
      return Left('Google sign-in failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, String>> logOut() async {
    try {
      await _firebaseService.signOutUser();
      return Right('Logged out successfully');
    } catch (e, stacktrace) {
      log('logout unexpected error: $e\n$stacktrace');
      return Left('Logout failed due to an unexpected error');
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUser() async {
    log("getCurrent User");
    try {
      final user = await _firebaseService.getCurrentAuthUser();
      if (user == null) {
        return Left('No logged-in user');
      }
      
      if (!user.emailVerified) {
        return Left('Email not verified');
      }

      final userModel = await _firebaseService.getUserFromFirestore(user.uid);
      if (userModel == null) {
        return Left('User profile not found');
      }

      return Right(userModel);
    } catch (e, stacktrace) {
      log('getCurrentUser unexpected error: $e\n$stacktrace');
      return Left('Failed to get current user due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, String>> sendEmailVerification() async {
    try {
      final user = await _firebaseService.getCurrentAuthUser();
      if (user == null) {
        return Left('No user signed in');
      }

      if (user.emailVerified) {
        return Right('Email already verified');
      }

      await _firebaseService.sendVerificationEmail();
      return Right('Verification email sent to ${user.email}');
    } catch (e, stacktrace) {
      log('sendEmailVerification unexpected error: $e\n$stacktrace');
      return Left('Failed to send email verification due to an unexpected error');
    }
  }
    
  @override
  Future<Either<String, UserEntity>> registerUser(UserEntity user) async {
    try {
      final currentUser = await _firebaseService.getCurrentAuthUser();
      if (currentUser == null) {
        return Left("No authenticated user");
      }

      if (!currentUser.emailVerified) {
        return Left("Email not verified");
      }

      log('registering user');

      // Update user model with additional info
      final userModel = UserModel.fromEntity(user).copyWith(
        tutorId: currentUser.uid,
        emailVerified: true,
        infoSubmitted: true,
        isVerified: false
      );

      // Save updated user to Firestore
      await _firebaseService.saveUserToFirestore(userModel);

      return Right(userModel.toEntity());
    } catch (e, stacktrace) {
      log('registerUser unexpected error: $e\n$stacktrace');
      return Left('Failed to register user due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    log(email);
    try {
      if (email.isEmpty) {
        return Left('Email required');
      }
      
      await _firebaseService.resetPassword(email);
      return Right('Password reset email sent');
    } catch (e, stacktrace) {
      log('sendPasswordResetEmail unexpected error: $e\n$stacktrace');
      return Left('Failed to send password reset email due to an unexpected error');
    }
  }
  
  @override
  Future<Either<String, bool>> checkIfUserExists(String email) async {
    try {
      final methods = await _firebaseService.getSignInMethodsForEmail(email);
      log(methods.toString());
      return Right(methods.isNotEmpty);
    } catch (e, stacktrace) {
      log('checkIfUserExists unexpected error: $e\n$stacktrace');
      return Left('Failed to check if user exists due to an unexpected error');
    }
  }
  
  @override
Future<Either<String, bool>> checkIfUserVerifiedByAdmin(UserEntity user) async {
  try {
    final currentUser = await _firebaseService.getCurrentAuthUser();
    if (currentUser == null) {
      return Left('No signed-in user');
    }

    // Fetch user document from Firestore
    final userDoc = await _firebaseService.getUserDocById(currentUser.uid);

    if (!userDoc.exists) {
      return Left('User record not found in Firestore');
    }

    final data = userDoc.data() as Map<String, dynamic>;
    final isVerified = data['is_verified'] as bool? ?? false;

    log('Admin verification status: $isVerified');
    return Right(isVerified);
  } catch (e, stacktrace) {
    log('checkIfUserVerifiedByAdmin error: $e\n$stacktrace');
    return Left('Failed to check admin verification');
  }
}


@override
Future<Either<String, bool>> isEmailVerified(UserEntity user) async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return Left('No signed-in user');
    }

    await firebaseUser.reload(); // Refresh user info from Firebase Auth
    final refreshedUser = FirebaseAuth.instance.currentUser;

    final isVerified = refreshedUser?.emailVerified ?? false;

    if (isVerified) {
      final userModel = UserModel.fromEntity(user).copyWith(
        emailVerified: true,
        updatedDate: DateTime.now(),
      );
      await _firebaseService.saveUserToFirestore(userModel);
    }

    log('Email verified: $isVerified');
    return Right(isVerified);
  } catch (e, stacktrace) {
    log('isEmailVerified unexpected error: $e\n$stacktrace');
    return Left('Failed to check isEmailVerified');
  }
}


}
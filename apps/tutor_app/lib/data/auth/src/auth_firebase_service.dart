import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';

abstract class AuthFirebaseService {
  Future<Either<String, dynamic>> signUp(UserCreationReq user);
  Future<Either<String, UserModel>> signIn(UserSignInReq user);
  Future<Either<String, UserModel>> signInWithGoogle();
  Future<Either<String, String>> logout();
  Future<Either<String, UserModel>> getCurrentUser();
  Future<Either<String, String>> sendEmailVerification();
  Future<Either<String, String>> sendPasswordResetEmail(String email);
  Future<Either<String, String>> registerUser(UserCreationReq user);
  Future<Either<String, bool>> isEmailVerified();
  Future<Either<String, bool>> checkIfUserExists(String email);
}

class AuthFirebaseServiceImp extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Collection reference
  final CollectionReference _mentorsCollection = 
      FirebaseFirestore.instance.collection('mentors');

  @override
  Future<Either<String, dynamic>> signUp(UserCreationReq user) async {
    try {
      // Validate inputs
      if (user.email == null || user.email!.isEmpty) {
        return Left("Email cannot be empty");
      }
      
      if (user.password == null || user.password!.isEmpty) {
        return Left("Password cannot be empty");
      }
      
      if (user.password!.length < 6) {
        return Left("Password must be at least 6 characters");
      }

      final existingUser = await checkIfUserExists(user.email!);
      
      if (existingUser.isRight()) {
        final exists = existingUser.getOrElse(() => false);
        if (exists) {
          // Try to handle existing user scenario
          try {
            final userCredential = await _auth.signInWithEmailAndPassword(
              email: user.email!,
              password: user.password!,
            );
            
            if (!userCredential.user!.emailVerified) {
              await userCredential.user!.sendEmailVerification();
              await _auth.signOut(); // Sign out after sending verification
              return Right("Account exists but not verified. Verification email sent.");
            } else {
              await _auth.signOut(); // Sign out if email is verified
              return Left("Email already verified. Please login.");
            }
          } catch (e) {
            return Left("Email already exists. Please login or reset your password.");
          }
        }
      }

  
      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
     
      if (user.name != null && user.name!.isNotEmpty) {
        await credential.user!.updateDisplayName(user.name);
      }
      
      // Send verification email
      await credential.user!.sendEmailVerification();

      return Right(
        UserModel(
          userId: credential.user!.uid,
          email: credential.user!.email ?? '',
          name: user.name ?? '',
          image: credential.user!.photoURL ?? '',
        )
      );
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during signup: ${e.code}");
      
      switch (e.code) {
        case 'email-already-in-use':
          return Left("Email already in use. Please login or reset your password.");
        case 'invalid-email':
          return Left("Invalid email format.");
        case 'weak-password':
          return Left("Password is too weak. Use at least 6 characters.");
        case 'operation-not-allowed':
          return Left("Account creation is disabled.");
        default:
          return Left("Sign up failed: ${e.message}");
      }
    } catch (e) {
      log("Exception during signup: $e");
      return Left("Sign up failed due to an unexpected error.");
    }
  }

  @override
  Future<Either<String, UserModel>> signIn(UserSignInReq user) async {
    try {
      // Validate inputs
      if (user.email == null || user.email!.isEmpty) {
        return Left("Email cannot be empty");
      }
      
      if (user.password == null || user.password!.isEmpty) {
        return Left("Password cannot be empty");
      }

      // Check if user is registered and approved in Firestore
      var userQuery = await _mentorsCollection
          .where('email', isEqualTo: user.email)
          .get();

      if (userQuery.docs.isEmpty) {
        return Left("User not registered");
      }

      var userData = userQuery.docs.first.data() as Map<String, dynamic>;

      // Check if user is approved
      if (userData['isApproved'] == false) {
        return Left("Your account is not approved yet. Please wait for admin approval.");
      }

      // Firebase Authentication
      var authResponse = await _auth.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      // Check if email is verified
      if (!authResponse.user!.emailVerified) {
        // Send a new verification email
        await authResponse.user!.sendEmailVerification();
        await _auth.signOut(); // Sign out if email not verified
        return Left("Email not verified. A new verification email has been sent.");
      }

      // Update user's last login timestamp
      await _mentorsCollection.doc(authResponse.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return Right(
        UserModel(
          userId: authResponse.user!.uid,
          email: authResponse.user!.email ?? '',
          name: authResponse.user!.displayName ?? userData['name'] ?? '',
          image: authResponse.user!.photoURL ?? userData['image'] ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during signin: ${e.code}");
      
      switch (e.code) {
        case 'invalid-email':
          return Left("Invalid email format");
        case 'user-disabled':
          return Left("This account has been disabled");
        case 'user-not-found':
          return Left("No account found with this email");
        case 'wrong-password':
        case 'invalid-credential':
          return Left("Incorrect password");
        default:
          return Left("Login failed: ${e.message}");
      }
    } catch (e) {
      log("Exception during signin: $e");
      return Left("Login failed due to an unexpected error");
    }
  }

  @override
  Future<Either<String, UserModel>> signInWithGoogle() async {
    try {
      // Begin Google sign in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return Left("Google sign in was cancelled");
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with credential
      UserCredential authResponse = await _auth.signInWithCredential(credential);
      
      if (authResponse.user == null) {
        return Left("Failed to authenticate with Google");
      }

      // Check if user exists in Firestore
      final userDoc = await _mentorsCollection.doc(authResponse.user!.uid).get();
      
      // Default approval status for new Google sign-ins
      bool isApproved = false;
      
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>?;
        // Preserve existing approval status if user exists
        isApproved = userData?['isApproved'] ?? false;
      }

      // Update or create user document in Firestore
      await _mentorsCollection.doc(authResponse.user!.uid).set({
        'email': authResponse.user!.email,
        'name': authResponse.user!.displayName ?? 'User',
        'image': authResponse.user!.photoURL ?? '',
        'isApproved': isApproved, // Set approval status
        'authProvider': 'google',
        'lastLogin': FieldValue.serverTimestamp(),
        'createdAt': userDoc.exists ? FieldValue.serverTimestamp() : FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Check if user is approved
      if (!isApproved) {
        await _auth.signOut();
        return Left("Your account requires approval. Please wait for admin approval.");
      }

      return Right(
        UserModel(
          userId: authResponse.user!.uid,
          email: authResponse.user!.email ?? '',
          name: authResponse.user!.displayName ?? '',
          image: authResponse.user!.photoURL ?? '',
        )
      );
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during Google signin: ${e.code}");
      return Left("Google sign in failed: ${e.message}");
    } catch (e) {
      log("Exception during Google signin: $e");
      return Left("Google sign in failed due to an unexpected error");
    }
  }
  
  @override
  Future<Either<String, String>> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut(); // Also sign out from Google
      
      return Right('Logged out successfully');
    } catch (e) {
      log("Exception during logout: $e");
      return Left('Logout failed: $e');
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      
      if (firebaseUser == null) {
        return Left('No logged-in user');
      }

      // Check if email is verified
      if (!firebaseUser.emailVerified) {
        return Left('Email not verified');
      }

      // Get user data from Firestore
      final doc = await _mentorsCollection.doc(firebaseUser.uid).get();

      if (!doc.exists) {
        return Left('User profile not found');
      }

      final data = doc.data() as Map<String, dynamic>;

      // Check if user is approved
      if (data['isApproved'] == false) {
        await _auth.signOut(); // Sign out if not approved
        return Left('Your account is not approved yet');
      }

      return Right(
        UserModel(
          userId: firebaseUser.uid,
          email: data['email'] ?? firebaseUser.email ?? '',
          name: data['name'] ?? firebaseUser.displayName ?? '',
          image: data['image'] ?? firebaseUser.photoURL ?? '',
        ),
      );
    } catch (e) {
      log("Exception while getting current user: $e");
      return Left('Failed to fetch user: $e');
    }
  }

  @override
  Future<Either<String, String>> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        return Left('No user is currently signed in');
      }

      if (user.emailVerified) {
        return Right('Email is already verified');
      }

      await user.sendEmailVerification();
      return Right('Verification email has been sent to ${user.email}');
    } catch (e) {
      log("Exception during email verification: $e");
      return Left('Failed to send verification email: $e');
    }
  }

  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        return Left('Email cannot be empty');
      }

      // Check if user exists in Firebase Auth first
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      
      if (methods.isEmpty) {
        return Left('No account found with this email');
      }

      await _auth.sendPasswordResetEmail(email: email);
      return Right('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException during password reset: ${e.code}");
      
      switch (e.code) {
        case 'invalid-email':
          return Left('Invalid email format');
        case 'user-not-found':
          return Left('No account found with this email');
        default:
          return Left('Failed to send password reset email: ${e.message}');
      }
    } catch (e) {
      log("Exception during password reset: $e");
      return Left('Failed to send password reset email');
    }
  }

  @override
  Future<Either<String, String>> registerUser(UserCreationReq user) async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        return Left("No authenticated user found");
      }

      // Check if email is verified
      if (!firebaseUser.emailVerified) {
        return Left("Please verify your email before completing registration");
      }

      final uid = firebaseUser.uid;

      // Create or update user profile in Firestore
      await _mentorsCollection.doc(uid).set({
        'email': firebaseUser.email,
        'name': user.name ?? firebaseUser.displayName ?? 'User',
        'userId': uid,
        'isApproved': false, // Default to not approved
        'emailVerified': firebaseUser.emailVerified,
      }, SetOptions(merge: true));

      return Right("Registration completed. Waiting for admin approval.");
    } catch (e) {
      log("Exception during user registration: $e");
      return Left("Registration failed: $e");
    }
  }

  @override
  Future<Either<String, bool>> isEmailVerified() async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        return Left('No user is currently signed in');
      }

      await user.reload();
      
      return Right(user.emailVerified);
    } catch (e) {
      log("Exception checking email verification: $e");
      return Left('Failed to check email verification status');
    }
  }

  @override
  Future<Either<String, bool>> checkIfUserExists(String email) async {
    try {
      // Check with Firebase Auth
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      
      if (methods.isNotEmpty) {
        return Right(true);
      }
      
      // Double-check with Firestore for completeness
      final querySnapshot = await _mentorsCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
          
      return Right(querySnapshot.docs.isNotEmpty);
    } catch (e) {
      log("Exception checking if user exists: $e");
      return Left('Failed to check if user exists');
    }
  }
}
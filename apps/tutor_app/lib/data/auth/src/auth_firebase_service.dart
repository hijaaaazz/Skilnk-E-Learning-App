import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
abstract class AuthFirebaseService {
  Future<Either<String, UserModel>> signUp(UserCreationReq user);
  Future<Either<String, UserModel>> signIn(UserSignInReq user);
  Future<Either<String, UserModel>> signInWithGoogle();
  Future<Either<String, String>> logout();
  Future<Either<String, UserModel>> getCurrentUser();
  Future<Either<String, String>> sendEmailVerification();
  Future<Either<String, String>> sendPasswordResetEmail(String email);
  Future<Either<String, dynamic>> registerUser(UserModel user);
  Future<Either<String, bool>> isEmailVerified();
  Future<Either<String, bool>> checkIfUserExists(String email);
}

class AuthFirebaseServiceImp extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _users = FirebaseFirestore.instance.collection('mentors');


@override  Future<Either<String, UserModel>> signUp(UserCreationReq user) async {
  try {
    if (user.email?.isEmpty ?? true) return Left("Email cannot be empty");
    if (user.password?.isEmpty ?? true) return Left("Password cannot be empty");
    if (user.password!.length < 6) return Left("Password must be at least 6 characters");

    final email = user.email!;

    // Create user with Firebase Auth
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: user.password!,
    );

    final firebaseUser = credential.user!;
    
    // Update display name
    if (user.name?.isNotEmpty ?? false) {
      await firebaseUser.updateDisplayName(user.name);
    }

    // Send email verification
    await firebaseUser.sendEmailVerification();

    // Save user data in Firestore
    await FirebaseFirestore.instance.collection('mentors').doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'name': user.name ?? '',
      'email': email,
      'image': firebaseUser.photoURL ?? '',
      'emailVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return Right(UserModel(
      userId: firebaseUser.uid,
      email: email,
      name: user.name ?? '',
      image: firebaseUser.photoURL ?? '',
      emailVerified: false,
    ));
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return Left("Email already registered. Please login.");
    }
    return Left("Auth error: ${e.message}");
  } catch (e) {
    return Left("Unexpected error during signup.");
  }
}

@override
Future<Either<String, UserModel>> signIn(UserSignInReq user) async {
  try {
    log('Sign In Auth call started');
    if (user.email?.isEmpty ?? true) return Left("Email required");
    if (user.password?.isEmpty ?? true) return Left("Password required");

    final email = user.email!;

    // Step 1: Sign in with Firebase Auth
    final authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: user.password!,
    );

    final firebaseUser = authResult.user!;
    await firebaseUser.reload();
    final refreshedUser = _auth.currentUser!;

    // Step 2: Check if this email exists in "users" or "admins" collection
    final firestore = FirebaseFirestore.instance;

    final userDoc = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final adminDoc = await firestore
        .collection('admins')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userDoc.docs.isNotEmpty || adminDoc.docs.isNotEmpty) {
      await _auth.signOut();
      log("no entry mone");
      return Left("You are not allowed to login from Tutor app");
    }

    // Step 3: Check email verification
    if (!refreshedUser.emailVerified) {
      await refreshedUser.sendEmailVerification();
      return Right(UserModel(
        userId: refreshedUser.uid,
        email: refreshedUser.email ?? '',
        name: refreshedUser.displayName ?? '',
        image: refreshedUser.photoURL ?? '',
        emailVerified: false,
      ));
    }

    // Step 4: Get tutor data from "tutors" collection
    final tutorDoc = await _users.doc(refreshedUser.uid).get();
    final tutorData = tutorDoc.data() as Map<String, dynamic>? ?? {};

    log("Tutor login success");
    return Right(UserModel(
      userId: refreshedUser.uid,
      email: refreshedUser.email ?? '',
      name: refreshedUser.displayName ?? tutorData['name'] ?? '',
      image: refreshedUser.photoURL ?? tutorData['image'] ?? '',
      emailVerified: true,
    ));
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
  } catch (e) {
    return Left("Login failed: unexpected error");
  }
}



  @override
Future<Either<String, UserModel>> signInWithGoogle() async {
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return Left("Google sign in cancelled");

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final firebaseUser = authResult.user;
    if (firebaseUser == null) return Left("Google authentication failed");

    final email = firebaseUser.email ?? '';
    final firestore = FirebaseFirestore.instance;

    // Check if the email exists in 'users' or 'admins' collection
    final userCheck = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final adminCheck = await firestore
        .collection('admins')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userCheck.docs.isNotEmpty || adminCheck.docs.isNotEmpty) {
      await _auth.signOut();
      await _googleSignIn.signOut();
      log('no entry');
      return Left("You are not allowed to login from Tutor app");
    }

    // Save to 'tutors' collection
    await _users.doc(firebaseUser.uid).set({
      'uid':firebaseUser.uid,
      'email': email,
      'name': firebaseUser.displayName ?? 'User',
      'image': firebaseUser.photoURL ?? '',
      'emailVerified': firebaseUser.emailVerified,
    }, SetOptions(merge: true));

    return Right(UserModel(
      userId: firebaseUser.uid,
      email: email,
      name: firebaseUser.displayName ?? '',
      image: firebaseUser.photoURL ?? '',
      emailVerified: true,
    ));
  } catch (e) {
    log(e.toString());
    return Left("Google sign in failed: $e");
  }
}

  
  @override
  Future<Either<String, String>> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return Right('Logged out successfully');
    } catch (e) {
      return Left('Logout failed: $e');
    }
  }

  @override
  Future<Either<String, UserModel>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null || !user.emailVerified) {
        return Left(user == null ? 'No logged-in user' : 'Email not verified');
      }

      final doc = await _users.doc(user.uid).get();
      if (!doc.exists) return Left('User profile not found');

      final data = doc.data() as Map<String, dynamic>;
     

      return Right(UserModel.fromJson(data));
    } catch (e) {
      return Left('Failed to fetch user: $e');
    }
  }

  @override
Future<Either<String, String>> sendEmailVerification() async {
  try {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Left('No user signed in');

    await currentUser.reload();
    if (currentUser.emailVerified) return Right('Email already verified');

    await currentUser.sendEmailVerification();
    return Right('Verification email sent to ${currentUser.email}');
  } catch (e) {
    return Left('Failed to send verification email');
  }
}


  @override
Future<Either<String, String>> sendPasswordResetEmail(String email) async {
  try {
    if (email.isEmpty) return Left('Email required');

    await _auth.sendPasswordResetEmail(email: email);
    return Right('Password reset email sent');
  } catch (e) {
    return Left('Failed to send reset email');
  }
}


  @override
Future<Either<String, dynamic>> registerUser(UserModel user) async {
  try {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Left("No authenticated user");

    // Reload to ensure latest emailVerified status
    await currentUser.reload();
    if (!currentUser.emailVerified) return Left("Email not verified");

    

    // Save to users collection
    log('registering user');
    await _users.doc(currentUser.uid).set({
      'userId': currentUser.uid,
      'name': user.name,
      'email': user.email,
      'emailVerified': true,
    
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return Right(UserModel(
      userId: currentUser.uid,
      name: user.name,
      email: user.email,
      emailVerified: true,
      
    ));
  } catch (e) {
    return Left("Registration failed: $e");
  }
}


  @override
Future<Either<String, bool>> isEmailVerified() async {
  try {
    final user = _auth.currentUser;
    if (user == null) return Left('No signed-in user');

    await user.reload();

    if (user.emailVerified) {
      // Delete from unverified_users if it exists
      final unverifiedDoc = await FirebaseFirestore.instance
          .collection('unverified_users')
          .doc(user.email)
          .get();

      if (unverifiedDoc.exists) {
        await FirebaseFirestore.instance
            .collection('unverified_users')
            .doc(user.email)
            .delete();
      }
    }
  log(user.emailVerified.toString());
    return Right(user.emailVerified);
  } catch (e) {
    return Left('Failed to check verification status');
  }
}


  @override
Future<Either<String, bool>> checkIfUserExists(String email) async {
  try {
    final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    log(methods.toString());
    return Right(methods.isNotEmpty);
  } catch (e) {
    return Left('Failed to check user');
  }
}
}
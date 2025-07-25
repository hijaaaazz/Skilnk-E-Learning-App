import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import  'package:user_app/features/auth/data/models/user_model.dart';

abstract class AuthFirebaseService {
  Future<Either<String, UserCredential>> createUserWithEmailPassword(String email, String password);
  Future<Either<String, UserCredential>> loginWithEmailPassword(String email, String password);
  Future<Either<String, User?>> signInWithGoogle();
  Future<Either<String, String>> logout();
  Future<Either<String, User?>> getCurrentFirebaseUser();
  Future<Either<String, Map<String, dynamic>?>> getUserData(String uid);
  Future<Either<String, String>> sendEmailVerification();
  Future<Either<String, String>> sendPasswordResetEmail(String email);
  Future<Either<String, String>> saveUserToFirestore(UserModel user);
  Future<Either<String, bool>> isEmailVerified();
  Future<Either<String, List<String>>> fetchSignInMethodsForEmail(String email);
  Future<Either<String, bool>> checkInRestrictedCollections(String email);
  Future<Either<String, String>> updateDisplayName(String uid, String name);
  Future<Either<String, bool>> deleteUserData(String id,String userPassword);
}

class AuthFirebaseServiceImp extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, UserCredential>> createUserWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Authentication error");
    } catch (e) {
      return Left("Failed to create user");
    }
  }

 @override
Future<Either<String, UserCredential>> loginWithEmailPassword(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ✅ Block check after sign-in
    final userId = credential.user?.uid;
    final userDoc = await _users.doc(userId).get();
    final data = userDoc.data() as Map<String, dynamic>?;

    if (data != null && data['isBlocked'] == true) {
      await _auth.signOut(); // Log out the user immediately
      return Left('Your account has been blocked by the admin.');
    }

    return Right(credential);
  } on FirebaseAuthException catch (e) {
    return Left(e.message ?? "Authentication error");
  } catch (e) {
    return Left("Failed to login");
  }
}


  @override
  Future<Either<String, User?>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return Right(null);

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);
      final userDoc = await _users.doc(authResult.user?.uid).get();
      final data = userDoc.data() as Map<String, dynamic>?;

      if (data != null && data['isBlocked'] == true) {
        await _auth.signOut();
        return Left('Your account has been blocked by the admin.');
      }

      return Right(authResult.user);
    } catch (e) {
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
  Future<Either<String, User?>> getCurrentFirebaseUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
      }
      return Right(_auth.currentUser);
    } catch (e) {
      return Left('Failed to get current user');
    }
  }

 @override
Future<Either<String, Map<String, dynamic>?>> getUserData(String uid) async {
  try {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) {
      return Right(null); // User not found
    }

    final data = doc.data() as Map<String, dynamic>;

    if (data['isblocked'] == true) {
      return Left('blocked'); // Send a signal to handle in UI layer
    }

    return Right(data);
  } catch (e) {
    return Left('Failed to fetch user data');
  }
}


  @override
  Future<Either<String, String>> sendEmailVerification() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return Left('No user signed in');
      await currentUser.sendEmailVerification();
      return Right('Verification email sent');
    } catch (e) {
      return Left('Failed to send verification email');
    }
  }
  
  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Right('Password reset email sent');
    } catch (e) {
      return Left('Failed to send reset email');
    }
  }

  @override
  Future<Either<String, String>> saveUserToFirestore(UserModel user) async {
    try {
      await _users.doc(user.userId).set({
        'userId': user.userId,
        'name': user.name,
        'email': user.email,
        'image': user.image ?? '',
        'emailVerified': user.emailVerified,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return Right('User saved successfully');
    } catch (e) {
      return Left('Failed to save user data');
    }
  }

  @override
  Future<Either<String, bool>> isEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left('No signed-in user');
      await user.reload();
      return Right(user.emailVerified);
    } catch (e) {
      return Left('Failed to check verification status');
    }
  }

  @override
  Future<Either<String, List<String>>> fetchSignInMethodsForEmail(String email) async {
    try {
      // ignore: deprecated_member_use
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return Right(methods);
    } catch (e) {
      return Left('Failed to check user');
    }
  }

  @override
  Future<Either<String, bool>> checkInRestrictedCollections(String email) async {
    try {
      // Check if this email exists in mentors or admin collections
      final mentorCheck = await _firestore
          .collection('mentors')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      final adminCheck = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return Right(mentorCheck.docs.isNotEmpty || adminCheck.docs.isNotEmpty);
    } catch (e) {
      return Left('Failed to check restricted collections');
    }
  }

  @override
  Future<Either<String, String>> updateDisplayName(String uid, String name) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left('No user signed in');
      await user.updateDisplayName(name);
      return Right('Display name updated');
    } catch (e) {
      return Left('Failed to update display name');
    }
  }

  
  @override
Future<Either<String, bool>> deleteUserData(String id, String userPassword) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      log("No user is currently signed in.");
      return Left("No user is signed in.");
    }

    log("Current user UID: ${user.uid}, target ID: $id");

    if (user.uid != id) {
      log("UID mismatch. Aborting delete.");
      return Left("User ID mismatch.");
    }

    final email = user.email;
    if (email == null) {
      log("User email is null.");
      return Left("User email is null. Cannot reauthenticate.");
    }

    // Always use email/password credential for reauthentication
    final credential = EmailAuthProvider.credential(email: email, password: userPassword);

    try {
      await user.reauthenticateWithCredential(credential);
      log("✅ Reauthentication with password successful.");
    } on FirebaseAuthException catch (e) {
      log("❌ Reauthentication failed: ${e.message}");
      return Left("Wrong password or reauthentication failed: ${e.message}");
    }

    // Proceed to delete only if reauth was successful
    await user.delete();
    log("✅ Firebase Auth user deleted.");

    await FirebaseFirestore.instance.collection('users').doc(id).delete();
    log("✅ Firestore document deleted.");

    return Right(true);
  } catch (e) {
    log("❌ General error: $e");
    return Left("Failed to delete user data: $e");
  }
}
 

}
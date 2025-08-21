import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_app/features/auth/data/models/delete_data_params.dart';
import 'package:tutor_app/features/auth/data/models/user_model.dart';

abstract class AuthFirebaseService {
  // Firebase Auth operations
  Future<UserCredential> createUserWithEmailPassword(String email, String password);
  Future<UserCredential> signInWithEmailPassword(String email, String password);
  Future<UserCredential?> authenticateWithGoogle();
  Future<void> signOutUser();
  Future<User?> getCurrentAuthUser();
  Future<void> sendVerificationEmail();
  Future<void> resetPassword(String email);
  Future<List<String>> getSignInMethodsForEmail(String email);
  Future<void> updateUserDisplayName(String name);
  
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocById(String uid);

  Future<void> saveUserToFirestore(UserModel user);
  Future<UserModel?> getUserFromFirestore(String uid);
  Future<bool> checkUserCollectionForEmail(String email, String collectionName);
  Future<Either<String,bool>> deleteUserData(DeleteUserParams params);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth operations
  @override
  Future<UserCredential> createUserWithEmailPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential?> authenticateWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> signOutUser() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<User?> getCurrentAuthUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
    return _auth.currentUser;
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<List<String>> getSignInMethodsForEmail(String email) async {
    // ignore: deprecated_member_use
    return await _auth.fetchSignInMethodsForEmail(email);
  }

  @override
  Future<void> updateUserDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
    }
  }

  // Firestore operations
  @override
  Future<void> saveUserToFirestore(UserModel user) async {
    await _firestore.collection('mentors').doc(user.tutorId).set(
      user.toJson(),
      SetOptions(merge: true),
    );
  }

 @override
Future<UserModel?> getUserFromFirestore(String uid) async {
  final doc = await _firestore.collection('mentors').doc(uid).get();
  if (doc.exists && doc.data() != null) {
    final user = UserModel.fromJson(doc.data()!);
    log(user.toString()); // Log the entire object
    return user;
  }
  return null;
}


  @override
  Future<bool> checkUserCollectionForEmail(String email, String collectionName) async {
    final querySnapshot = await _firestore
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    
    return querySnapshot.docs.isNotEmpty;
  }
  
  @override
Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocById(String uid) async {
  return await FirebaseFirestore.instance.collection('mentors').doc(uid).get();
}
@override
  Future<Either<String, bool>> deleteUserData(DeleteUserParams params) async {
  try {
    final user = _auth.currentUser;

    // Step 1: Reauthenticate
    if (user != null && user.email == params.email) {
      final credential = EmailAuthProvider.credential(
        email: params.email,
        password: params.password,
      );

      await user.reauthenticateWithCredential(credential);
    } else {
      return Left("User mismatch or not signed in.");
    }

    // Step 2: Replace Firestore data with placeholder
    final placeholderUser = UserModel(
      tutorId: params.userId,
      name: "Deleted User",
      username: null,
      email: "deleted-${DateTime.now().millisecondsSinceEpoch}@example.com",
      phone: null,
      image: null,
      bio: null,
      emailVerified: false,
      isVerified: false,
      status: false,
      isBlocked: false,
      courseIds: [],
      categories: [],
      savedCourses: [],
      lastActive: DateTime.now(),
      lastLogin: DateTime.now(),
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      infoSubmitted: false,
    );

    await _firestore.collection('mentors').doc(params.userId).set(
      placeholderUser.toJson(),
      SetOptions(merge: true),
    );

    // Step 3: Delete user
    await user.delete();

    return Right(true);
  } catch (e) {
    return Left("Error deleting user: ${e.toString()}");
  }
}


}
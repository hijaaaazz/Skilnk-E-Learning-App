import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
abstract class AuthFirebaseService {

  Future<Either> signUp (UserCreationReq user);
  Future<Either> signIn (UserSignInReq user);
  Future<Either> signInWithGoogleUseCase ();
  Future<Either> logout ();
  Future<Either> getCurrentUser();
  Future<Either>sendEmailVerification();

}


class AuthFirebaseServiceImp extends AuthFirebaseService{

  @override
  Future<Either> signUp(UserCreationReq user) async {
    try{

      print("Strted sign up");

      UserCredential authResponce = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!
      );

      

      return Right(
          UserModel(
            userId: authResponce.user!.uid,
            email: authResponce.user!.email ?? '',
            name: authResponce.user!.displayName ?? '',
            image: authResponce.user!.photoURL ?? '',
          )
      );

      
    }on FirebaseAuthException catch(e){

      String message = '';

      if(e.code == 'weak-password'){
        message = 'Password is too weak';
      }else if(e.code == 'email-already-in-use'){
        message = 'Email already exists';
      }

      return Left(message);

    }
  }
  
  @override
  Future<Either> signIn(UserSignInReq user) async{
    try{

      print("Strted sign up");

      var authResponce = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!
      );

    

      return Right(
          UserModel(
            userId: authResponce.user!.uid,
            email: authResponce.user!.email ?? '',
            name: authResponce.user!.displayName ?? '',
            image: authResponce.user!.photoURL ?? '',
          )
      );

      
    }on FirebaseAuthException catch(e){

      String message = '';

      if(e.code == 'invalid_email'){
        message = 'User not found';
      }else if(e.code == 'invalid-credential'){
        message = 'Wrong password';
      }

      return Left(message);

    }
  }
  
  @override
  Future<Either> signInWithGoogleUseCase() async {
    try{
      final googleUser = await GoogleSignIn().signIn();
      print("Strted sign up");

      final googleAuthResponse = await googleUser?.authentication;

      final userCredential = GoogleAuthProvider.credential(
        idToken: googleAuthResponse?.idToken,
        accessToken: googleAuthResponse?.accessToken
        );
      
      UserCredential authResponce = await FirebaseAuth.instance.signInWithCredential(
        userCredential
      );

      FirebaseFirestore.instance.collection('mentors').doc(
        authResponce.user!.uid
      ).set(
        {
          'email' : authResponce.user!.email,
          'name' : authResponce.user!.displayName,
          "image" : authResponce.user!.photoURL
        },
        SetOptions(merge: true)
      );

    

      return Right(
          UserModel(
            userId: authResponce.user!.uid,
            email: authResponce.user!.email ?? '',
            name: authResponce.user!.displayName ?? '',
            image: authResponce.user!.photoURL ?? '',
          )
      );

      
    }on FirebaseAuthException catch(e){

      String message = '';

      if(e.code == 'invalid_email'){
        message = 'User not found';
      }else if(e.code == 'invalid-credential'){
        message = 'Wrong password';
      }

      return Left(message);

    }
  }
  
  @override
  Future<Either> logout() async {
    try{

      print("Strted sign up");

      await FirebaseAuth.instance.signOut();

    

      return Right(
          'Log out Success'
      );

      
    }on FirebaseAuthException catch(e){

      String message = 'Log Out unsuccesfull';

      

      return Left(message);

    }
  }

  Future<Either> getCurrentUser() async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return Left('No logged-in user');
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    if (!doc.exists) {
      return Left('User data not found in Firestore');
    }

    final data = doc.data();

    return Right(
      UserModel(
        userId: firebaseUser.uid,
        email: data?['email'] ?? '',
        name: data?['name'] ?? '',
        image: data?['image'] ?? '',
        
      ),
    );
  } catch (e) {
    return Left('Failed to fetch user: $e');
  }
}

Future<Either> sendEmailVerification() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Left('No user is currently signed in.');
    }

    await user.sendEmailVerification();
    return Right('Verification email has been sent to ${user.email}.');
  } catch (e) {
    return Left('Failed to send verification email: $e');
  }
}





}
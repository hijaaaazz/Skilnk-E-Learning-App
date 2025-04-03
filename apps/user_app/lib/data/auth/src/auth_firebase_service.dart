import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';

abstract class AuthFirebaseService {

  Future<Either> signUp (UserCreationReq user);

}


class AuthFirebaseServiceImp extends AuthFirebaseService{

  @override
  Future<Either> signUp(UserCreationReq user) async {
    try{

      print("Strted sign up");

      var authResponce = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!
      );

      FirebaseFirestore.instance.collection('users').doc(
        authResponce.user!.uid
      ).set(
        {
          'name' : user.name,
          'email' : user.email,
          'password' : user.password
        }
      );

      return Right(
          'Signed Up Success'
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



}
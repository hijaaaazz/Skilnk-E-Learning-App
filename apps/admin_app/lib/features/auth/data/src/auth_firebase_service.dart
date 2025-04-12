import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFirebaseService {

  Future<Either> signIn (AdminSignInReq user);

}


class AuthFirebaseServiceImp extends AuthFirebaseService{

  @override
  Future<Either> signIn(AdminSignInReq user) async {
    try{


      var authResponce = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!
      );

      FirebaseFirestore.instance.collection('admin').doc(
        authResponce.user!.uid
      ).set(
        {
          'email' : user.email,
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
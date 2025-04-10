import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_model.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class SignInUseCase implements Usecase<Either<String, dynamic>, UserSignInReq> {
  @override
  Future<Either<String, dynamic>> call({required UserSignInReq params}) async {
    // Attempt to sign in
    final result = await serviceLocator<AuthRepository>().signIn(params);
    
    return result.fold(
      (error) => Left(error),
      (user) async {
        // Check if email is verified
        final verificationCheck = await serviceLocator<AuthRepository>().isEmailVerified();
        
        return verificationCheck.fold(
          (error) => Left(error),
          (isVerified) {
            if (isVerified) {
              // Email is verified, proceed with login
              log('User signed in successfully: ${user.email}');
              return Right(user);
            } else {
              // Email not verified, send another verification email and return message
              serviceLocator<AuthRepository>().sendEmailVerification();
              return const Right("Please verify your email before signing in. A new verification email has been sent.");
            }
          },
        );
      },
    );
  }
}
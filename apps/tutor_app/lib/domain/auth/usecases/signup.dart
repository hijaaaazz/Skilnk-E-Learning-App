// SignupUseCase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';

class SignupUseCase implements Usecase<Either<String, dynamic>, UserCreationReq> {
  @override
  Future<Either<String, dynamic>> call({required UserCreationReq params}) async {
    // First attempt to sign up
    final result = await serviceLocator<AuthRepository>().signUp(params);
    
    return await result.fold(
      (error) => Left(error),
      (success) async {
        // If it's just a message (like "Account exists but not verified..."), return it
        if (success is String) {
          return Right(success);
        }
        
        // Otherwise, it's a successful signup, so handle verification and registration
        final emailResult = await serviceLocator<AuthRepository>().sendEmailVerification();
        
        return await emailResult.fold(
          (emailError) => Left(emailError),
          (_) async {
            final registerResult = await serviceLocator<AuthRepository>().registerUser(params);
            
            return registerResult.fold(
              (registerError) => Left(registerError),
              (_) => Right(success),
            );
          },
        );
      },
    );
  }
}



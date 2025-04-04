import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:admin_app/features/auth/domain/repository/auth.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class SignInusecase implements Usecase<Either, AdminSignInReq?> {  // Use nullable type
  @override
  Future<Either> call({ AdminSignInReq? params}) async {  // Optional params
    if (params == null) {
      return Left("No params provided");
    }


    try {
      Either response =
          await serviceLocator<AuthRepository>().signUp(params);
      return response;
    } catch (e) {
      return Left("Signup failed: $e");
    }
  }
}

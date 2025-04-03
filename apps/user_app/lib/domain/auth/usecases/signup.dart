import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';


class Signupusecase implements Usecase<Either, UserCreationReq> {
  @override
  Future<Either> call({required UserCreationReq params}) async {
    print("⚡ usecase.call() executed with params: $params");

    try {
      Either response =
          await serviceLocator<AuthRepository>().signUp(params);
      print("✅ signUp completed: $response");
      return response;
    } catch (e) {
      print("🔥 Exception in usecase.call(): $e");
      return Left("Signup failed: $e");
    }
  }
}

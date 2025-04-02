import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/service_locator.dart';

class Signupusecase implements Usecase<Either,UserCreationReq>{

  
  @override
  Future<Either> call({UserCreationReq? params}) async {
    return await serviceLocator<AuthRepository>().signUp(params!);
  }



}


// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/auth/data/models/user_model.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';

class GetCurrentUserUseCase implements Usecase<Either<String, UserModel>, NoParams> {
  @override
  Future<Either<String, UserModel>> call({NoParams? params}) {
    return serviceLocator<AuthRepository>().getCurrentUser();
  }
}
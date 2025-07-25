
// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/account/domain/repo/profile_repo.dart';
import  'package:user_app/service_locator.dart';

class DeleteUserdataUserUseCase implements Usecase<Either<String, bool>, DeleteUserParams> {
  @override
  Future<Either<String, bool>> call({required DeleteUserParams params}) {
    return serviceLocator<ProfileRepository>().deleteUserData(params.id,params.password);
  }
}

final class DeleteUserParams{
  String id;
  String password;
  DeleteUserParams({
    required this.id,
    required this.password
  });

}

// LogoutUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/data/models/delete_data_params.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';
class DeleteAccounttUseCase implements Usecase<Either<String, bool>, DeleteUserParams> {
  @override
  Future<Either<String, bool>> call({required DeleteUserParams params}) {
    return serviceLocator<AuthRepository>().deleteAccount(params);
  }
}

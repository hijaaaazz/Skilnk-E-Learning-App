import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/auth/domain/repository/auth.dart';
import  'package:user_app/service_locator.dart';

class SendEmailVerificationUseCase implements Usecase<Either<String, void>, NoParams> {
  @override
  Future<Either<String, void>> call({required NoParams params}) async {
    return await serviceLocator<AuthRepository>().sendEmailVerification();
  }
}

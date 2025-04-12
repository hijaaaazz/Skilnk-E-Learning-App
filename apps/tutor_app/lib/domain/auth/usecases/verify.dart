import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/domain/auth/repository/auth.dart';
import 'package:tutor_app/service_locator.dart';
class SendEmailVerificationUseCase implements Usecase<Either<String, void>, NoParams> {
  @override
  Future<Either<String, void>> call({required NoParams params}) async {
    return await serviceLocator<AuthRepository>().sendEmailVerification();
  }
}

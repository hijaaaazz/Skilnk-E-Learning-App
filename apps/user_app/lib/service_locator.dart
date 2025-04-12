import 'package:get_it/get_it.dart';
import 'package:user_app/data/auth/repository/auth_repo_imp.dart';
import 'package:user_app/data/auth/src/auth_firebase_service.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/domain/auth/usecases/check_verification.dart';
import 'package:user_app/domain/auth/usecases/get_user.dart';
import 'package:user_app/domain/auth/usecases/logout.dart';
import 'package:user_app/domain/auth/usecases/resent_verification.dart';
import 'package:user_app/domain/auth/usecases/reset_pass.dart';
import 'package:user_app/domain/auth/usecases/signin.dart';
import 'package:user_app/domain/auth/usecases/signin_with_google.dart';
import 'package:user_app/domain/auth/usecases/signup.dart';

final serviceLocator = GetIt.instance;


Future<void> initializeDependencies() async {
  // ✅ Services
  serviceLocator.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImp()
  );

  // ✅ Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  // ✅ Use Cases
  // Basic authentication use cases
  serviceLocator.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase()
  );
  
  serviceLocator.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase()
  );
  
  serviceLocator.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase()
  );
  
  serviceLocator.registerLazySingleton<LogOutUseCase>(
    () => LogOutUseCase()
  );
  
  serviceLocator.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase()
  );
  
  // Additional verification and password management use cases
  serviceLocator.registerLazySingleton<CheckVerificationUseCase>(
    () => CheckVerificationUseCase()
  );
  
  serviceLocator.registerLazySingleton<ResendVerificationEmailUseCase>(
    () => ResendVerificationEmailUseCase()
  );
  
  serviceLocator.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase()
  );
}


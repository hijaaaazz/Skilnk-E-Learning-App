import 'package:get_it/get_it.dart';
import 'package:user_app/data/auth/repository/auth_repo_imp.dart';
import 'package:user_app/data/auth/src/auth_firebase_service.dart';
import 'package:user_app/domain/auth/repository/auth.dart';
import 'package:user_app/domain/auth/usecases/signup.dart';

final serviceLocator = GetIt.instance;
Future<void> initializeDependencies() async {
  // ✅ Register services lazily
  serviceLocator.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImp()
  );

  // ✅ Register repositories lazily
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  // ✅ Register use cases lazily
  serviceLocator.registerLazySingleton<Signupusecase>(
    () => Signupusecase()
  );
}



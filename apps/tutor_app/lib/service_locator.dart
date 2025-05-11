import 'package:get_it/get_it.dart';
import 'package:tutor_app/features/auth/data/repository/auth_repo_imp.dart';
import 'package:tutor_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/features/auth/domain/usecases/admin_verification_check.dart';
import 'package:tutor_app/features/auth/domain/usecases/check_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/get_user.dart';
import 'package:tutor_app/features/auth/domain/usecases/logout.dart';
import 'package:tutor_app/features/auth/domain/usecases/resent_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/reset_pass.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:tutor_app/features/auth/domain/usecases/signup.dart';
import 'package:tutor_app/features/courses/data/repo/courses_repo.dart';
import 'package:tutor_app/features/courses/data/src/cloudinary_services.dart';
import 'package:tutor_app/features/courses/data/src/firebase_services.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';

final serviceLocator = GetIt.instance;


Future<void> initializeDependencies() async {
  // ✅ Services
  serviceLocator.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImpl()
  );

  serviceLocator.registerLazySingleton<CourseFirebaseService>(
    () => CoursesFirebaseServiceImpl()
  );

  serviceLocator.registerLazySingleton<CourseCloudinaryServices>(
    () => CourseCloudinaryServiceImp()
  );

  // ✅ Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  serviceLocator.registerLazySingleton<CoursesRepository>(
    () => CoursesRepoImplementation()
  );

  // ✅ Use Cases
  // Basic authentication use cases
  serviceLocator.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase()
  );

  serviceLocator.registerLazySingleton<CheckVerificationByAdminUseCase>(
    () => CheckVerificationByAdminUseCase()
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

  serviceLocator.registerLazySingleton<CreateCourseUseCase>(
    () => CreateCourseUseCase()
  );

  serviceLocator.registerLazySingleton<GetCourseOptionsUseCase>(
    () => GetCourseOptionsUseCase()
  );

}


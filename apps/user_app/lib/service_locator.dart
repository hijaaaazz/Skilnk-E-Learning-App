import 'package:get_it/get_it.dart';
import 'package:user_app/features/auth/data/repository/auth_repo_imp.dart';
import 'package:user_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:user_app/features/auth/domain/repository/auth.dart';
import 'package:user_app/features/auth/domain/usecases/check_verification.dart';
import 'package:user_app/features/auth/domain/usecases/get_user.dart';
import 'package:user_app/features/auth/domain/usecases/logout.dart';
import 'package:user_app/features/auth/domain/usecases/resent_verification.dart';
import 'package:user_app/features/auth/domain/usecases/reset_pass.dart';
import 'package:user_app/features/auth/domain/usecases/signin.dart';
import 'package:user_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:user_app/features/auth/domain/usecases/signup.dart';
import 'package:user_app/features/explore/data/repos/search_repo.dart';
import 'package:user_app/features/explore/data/src/firebase_services.dart';
import 'package:user_app/features/explore/domain/repos/search_repo.dart';
import 'package:user_app/features/explore/domain/usecases/get_search_results.dart';
import 'package:user_app/features/home/data/repos/course_repo.dart';
import 'package:user_app/features/home/data/src/firebase_service.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/features/home/domain/usecases/get_categories.dart';
import 'package:user_app/features/home/domain/usecases/get_course_details.dart';
import 'package:user_app/features/home/domain/usecases/get_courses.dart';
import 'package:user_app/features/home/domain/usecases/save_course.dart';
import 'package:user_app/features/library/data/repo/library_repo.dart';
import 'package:user_app/features/library/data/src/firebase_service.dart';
import 'package:user_app/features/library/domain/repo/library_repo.dart';
import 'package:user_app/features/library/domain/usecases/get_user_courses.dart';
import 'package:user_app/features/library/domain/usecases/getsaved_usecase.dart';
import 'package:user_app/features/payment/data/repo/enrollment_repo.dart';
import 'package:user_app/features/payment/data/src/enrollment_firebase_service.dart';
import 'package:user_app/features/payment/domain/repo/enrollment_repo.dart';
import 'package:user_app/features/payment/domain/usecase/enroll_course.dart';

final serviceLocator = GetIt.instance;


Future<void> initializeDependencies() async {
  // ✅ Services
  serviceLocator.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImp()
  );
  serviceLocator.registerLazySingleton<CoursesFirebaseService>(
    () => CoursesFirebaseServicesImp()
  );
  serviceLocator.registerLazySingleton<ExploreFirebaseService>(
    () => ExploreFirebaseServicesImp()
  );

  serviceLocator.registerLazySingleton<LibraryFirebaseService>(
    () => LibraryFirebaseServiceImp()
  );

  serviceLocator.registerLazySingleton<EnrollmentFirebaseService>(
    () => EnrollmentFirebaseServiceImp()
  );

  // ✅ Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  serviceLocator.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImp()
  );

  serviceLocator.registerLazySingleton<SearchAndFilterRepository>(
    () => SearchAndFilterRepositoryImp()
  );

  serviceLocator.registerLazySingleton<LibraryRepository>(
    () => LibraryRepositoryImpl()
  );

  serviceLocator.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImp()
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

  serviceLocator.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase()
  );

  serviceLocator.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase()
  );

  serviceLocator.registerLazySingleton<GetCourseDetailsUseCase>(
    () => GetCourseDetailsUseCase()
  );

  serviceLocator.registerLazySingleton<GetSearchResultsUseCase>(
    () => GetSearchResultsUseCase()
  );

  serviceLocator.registerLazySingleton<SaveCourseUseCase>(
    () => SaveCourseUseCase()
  );

  serviceLocator.registerLazySingleton<GetSavedCoursesUseCase>(
    () => GetSavedCoursesUseCase()
  );

  serviceLocator.registerLazySingleton<EnrollCoursesUseCase>(
    () => EnrollCoursesUseCase()
  );

  serviceLocator.registerLazySingleton<GetEnrolledCoursesUseCase>(
    () => GetEnrolledCoursesUseCase()
  );

  

  
}


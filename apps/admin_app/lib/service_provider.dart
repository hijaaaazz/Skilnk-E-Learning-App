import 'package:admin_app/features/auth/data/repository/auth_repo_imp.dart';
import 'package:admin_app/features/auth/domain/repository/auth.dart';
import 'package:admin_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:admin_app/features/auth/domain/usecases/signup.dart';
import 'package:admin_app/features/courses/data/repos/category_repo.dart';
import 'package:admin_app/features/courses/data/src/firebase_service.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/features/courses/domain/usecases/add_category.dart';
import 'package:admin_app/features/courses/domain/usecases/delete_category.dart';
import 'package:admin_app/features/courses/domain/usecases/get_categories.dart';
import 'package:admin_app/features/courses/domain/usecases/update_category.dart';
import 'package:admin_app/features/instructors/data/repos/user_management_repo.dart';
import 'package:admin_app/features/instructors/data/src/mentors_firebase_service.dart';
import 'package:admin_app/features/instructors/domain/repos/mentor_managment.dart';
import 'package:admin_app/features/instructors/domain/usecases/get_mentors.dart';
import 'package:admin_app/features/instructors/domain/usecases/update_mentor.dart';
import 'package:admin_app/features/users/data/repos/user_management_repo.dart';
import 'package:admin_app/features/users/data/src/users_firebase_service.dart';
import 'package:admin_app/features/users/domain/repos/user_managment.dart';
import 'package:admin_app/features/users/domain/usecases/get_users.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;
Future<void> initializeDependencies() async {
  // ✅ Services
  serviceLocator.registerLazySingleton<AuthFirebaseService>(
    () => AuthFirebaseServiceImp()
  );

  serviceLocator.registerLazySingleton<UsersFirebaseService>(
    () => UsersFirebaseServiceImp()
  );

  serviceLocator.registerLazySingleton<MentorsFirebaseService>(
    () => MentorsFirebaseServiceImp()
  );

  serviceLocator.registerLazySingleton<CategoryFirebaseService>(
    () => CategoryFirebaseServiceImp()
  );
  




  // ✅ Repos
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  serviceLocator.registerLazySingleton<UsersRepo>(
    () => UsersRepoImp()
  );

  serviceLocator.registerLazySingleton<MentorsRepo>(
    () => MentorsRepoImp()
  );

  serviceLocator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepoImplementation()
  );
  



  // ✅ Usecases
  serviceLocator.registerLazySingleton<SignInusecase>(
    () => SignInusecase()
  );

  serviceLocator.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase()
  );

  serviceLocator.registerLazySingleton<GetMentorsUseCase>(
    () => GetMentorsUseCase()
  );

  serviceLocator.registerLazySingleton<UpdateMentorUseCase>(
    () => UpdateMentorUseCase()
  );

  serviceLocator.registerLazySingleton<GetCategoryUsecase>(
    () => GetCategoryUsecase()
  );

  serviceLocator.registerLazySingleton<AddNewCategoryUsecase>(
    () => AddNewCategoryUsecase()
  );

  serviceLocator.registerLazySingleton<DeleteCategoryuseCase>(
    () => DeleteCategoryuseCase()
  );

  serviceLocator.registerLazySingleton<UpdateCategoryUseCase>(
    () => UpdateCategoryUseCase()
  );
}



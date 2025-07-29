import 'package:get_it/get_it.dart';
import 'package:tutor_app/features/account/data/repo/profile_repo.dart';
import 'package:tutor_app/features/account/data/service/profile_cloudinary_service.dart';
import 'package:tutor_app/features/account/data/service/profile_firebase_service.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/features/account/domain/usecase/add_category.dart';
import 'package:tutor_app/features/account/domain/usecase/delete_category.dart';
import 'package:tutor_app/features/account/domain/usecase/get_categories.dart';
import 'package:tutor_app/features/account/domain/usecase/update_bio.dart';
import 'package:tutor_app/features/account/domain/usecase/update_user_profile_pic.dart';
import 'package:tutor_app/features/account/domain/usecase/update_username.dart';
import 'package:tutor_app/features/auth/data/repository/auth_repo_imp.dart';
import 'package:tutor_app/features/auth/data/src/auth_firebase_service.dart';
import 'package:tutor_app/features/auth/domain/repository/auth.dart';
import 'package:tutor_app/features/auth/domain/usecases/admin_verification_check.dart';
import 'package:tutor_app/features/auth/domain/usecases/check_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:tutor_app/features/auth/domain/usecases/get_user.dart';
import 'package:tutor_app/features/auth/domain/usecases/logout.dart';
import 'package:tutor_app/features/auth/domain/usecases/resent_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/reset_pass.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:tutor_app/features/auth/domain/usecases/signup.dart';
import 'package:tutor_app/features/chat/data/repo/chat_repo_imp.dart';
import 'package:tutor_app/features/chat/data/service/firebase_chat.dart';
import 'package:tutor_app/features/chat/domain/repo/chat_repo.dart';
import 'package:tutor_app/features/chat/domain/usecaase/check_chat_exist.dart';
import 'package:tutor_app/features/chat/domain/usecaase/load_chat_list.dart';
import 'package:tutor_app/features/chat/domain/usecaase/loadchat_usecase.dart';
import 'package:tutor_app/features/chat/domain/usecaase/send_message_usecase.dart';
import 'package:tutor_app/features/courses/data/repo/courses_repo.dart';
import 'package:tutor_app/features/courses/data/src/cloudinary_services.dart';
import 'package:tutor_app/features/courses/data/src/firebase_services.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/features/courses/domain/usecases/course_edit.dart';
import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/delee_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_details.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_courses.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_reviews.dart';
import 'package:tutor_app/features/courses/domain/usecases/toggle_activation.dart';
import 'package:tutor_app/features/dashboard/data/repo/dash_board_repo.dart';
import 'package:tutor_app/features/dashboard/data/src/firebase_dashboard_service.dart';
import 'package:tutor_app/features/dashboard/domain/repo/dashboard_repo.dart';
import 'package:tutor_app/features/dashboard/domain/usecase/get_dashboard_item_usecase.dart';

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

  serviceLocator.registerLazySingleton<FirebaseDashboardService>(
    () => FirebaseDashboardServiceImp()
  );


  serviceLocator.registerLazySingleton<ChatFirebaseService>(
    () => ChatFirebaseServiceImp()
  );

  serviceLocator.registerLazySingleton<FirebaseProfileService>(
    () => FirebaseProfileServiceImp()
  );

  serviceLocator.registerLazySingleton<ProfileCloudinaryService>(
    () => ProfileCloudinaryServiceImp()
  );

  // ✅ Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthenticationRepoImplementation()
  );

  serviceLocator.registerLazySingleton<CoursesRepository>(
    () => CoursesRepoImplementation()
  );

  serviceLocator.registerLazySingleton<DashBoardRepo>(
    () => DashBoardRepoImp()
  );

  serviceLocator.registerLazySingleton<ChatRepository>(
    () => ChatRepoImp()
  );

  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImp()
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

  serviceLocator.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase()
  );
  
  serviceLocator.registerLazySingleton<GetCourseDetailUseCase>(
    () => GetCourseDetailUseCase()
  );

  serviceLocator.registerLazySingleton<DeleteCourseUseCase>(
    () => DeleteCourseUseCase()
  );

  serviceLocator.registerLazySingleton<UpdateCourseUseCase>(
    () => UpdateCourseUseCase()
  );

  serviceLocator.registerLazySingleton<ToggleCourseUseCase>(
    () => ToggleCourseUseCase()
  );

  serviceLocator.registerLazySingleton<GetDashboardItemUsecase>(
    () => GetDashboardItemUsecase()
  );
  serviceLocator.registerLazySingleton<LoadChatListUseCase>(
    () => LoadChatListUseCase()
  );
  serviceLocator.registerLazySingleton<LoadChatUseCase>(
    () => LoadChatUseCase()
  );
  serviceLocator.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase()
  );

  serviceLocator.registerLazySingleton<CheckChatExistsUseCase>(
    () => CheckChatExistsUseCase()
  );

  serviceLocator.registerLazySingleton<UpdateDpUserUseCase>(
    () => UpdateDpUserUseCase()
  );

  serviceLocator.registerLazySingleton<UpdateNameUserUseCase>(
    () => UpdateNameUserUseCase()
  );

   serviceLocator.registerLazySingleton<GetReviewsUseCase>(
    () => GetReviewsUseCase()
  );

  serviceLocator.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase()
  );

   serviceLocator.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase()
  );

   serviceLocator.registerLazySingleton<AddCategoryUseCase>(
    () => AddCategoryUseCase()
  );

   serviceLocator.registerLazySingleton<UpdateBioUseCase>(
    () => UpdateBioUseCase()
  );

  serviceLocator.registerLazySingleton<DeleteAccounttUseCase>(
    () => DeleteAccounttUseCase()
  );


}


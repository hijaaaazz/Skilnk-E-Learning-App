// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tutor_app/core/routes/app_route_constants.dart';
// import 'package:tutor_app/core/usecase/usecase.dart';
// import 'package:tutor_app/features/auth/data/models/user_creation_req.dart';
// import 'package:tutor_app/features/auth/data/models/user_signin_model.dart';
// import 'package:tutor_app/features/auth/domain/entity/user.dart';
// import 'package:tutor_app/features/auth/domain/usecases/check_verification.dart';
// import 'package:tutor_app/features/auth/domain/usecases/get_user.dart';
// import 'package:tutor_app/features/auth/domain/usecases/logout.dart';
// import 'package:tutor_app/features/auth/domain/usecases/register.dart';
// import 'package:tutor_app/features/auth/domain/usecases/resent_verification.dart';
// import 'package:tutor_app/features/auth/domain/usecases/reset_pass.dart';
// import 'package:tutor_app/features/auth/domain/usecases/signin.dart';
// import 'package:tutor_app/features/auth/domain/usecases/signin_with_google.dart';
// import 'package:tutor_app/features/auth/domain/usecases/signup.dart';
// import 'package:tutor_app/features/auth/domain/usecases/verify.dart';
// import 'package:tutor_app/service_locator.dart';

// enum AuthStatus {
//   unauthenticated,
//   authenticated,
//   emailVerified,
//   adminVerified,
//   failure,
//   loading,
// }

// class AuthState {
//   final AuthStatus status;
//   final String? message;
//   final UserEntity? user;

//   AuthState({required this.status, this.message, this.user});

//   factory AuthState.initial() =>
//       AuthState(status: AuthStatus.unauthenticated);
// }
// class ResetPasswordState extends AuthState{
//   ResetPasswordState({required super.status});
// }
// class ResetPasswordSentState extends ResetPasswordState{
//   ResetPasswordSentState({required super.status});
// }

// class ResetPasswordFailedState extends ResetPasswordState {
//   @override
//   // ignore: overridden_fields
//   final String message;

//   ResetPasswordFailedState({
//     required super.status,
//     required this.message,
//   });

// }

// class AuthBloc extends Cubit<AuthState> {
//   AuthBloc() : super(AuthState.initial());

//   // Sign Up
//   Future<void> signUp(UserCreationReq req) async {
//     emit(AuthState(status: AuthStatus.loading));
//     final result = await serviceLocator<SignupUseCase>().call(params: req);

    
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) {
        
//         emit(AuthState(status: AuthStatus.authenticated, user: r));
//       }
//     );
//   }

//   // Sign In
//   Future<void> signIn(UserSignInReq req) async {
//     log("SignIn");
//     emit(AuthState(status: AuthStatus.loading));
//     final result = await serviceLocator<SignInUseCase>().call(params: req);
//     result.fold(
//       (l) {
//         log(l);
//         emit(AuthState(status: AuthStatus.failure, message: l));
//       },
//       (r) {
//         log(r.toString());
//         if(r!.emailVerified){
//           emit(AuthState(status: AuthStatus.emailVerified, user: r));
//         }else{
//           emit(AuthState(status: AuthStatus.authenticated, user: r));
//         }
        
//       } 
//     );
//   }

//   // Sign In With Google
//   Future<void> signInWithGoogle() async {
//     emit(AuthState(status: AuthStatus.loading));
//     final result = await serviceLocator<SignInWithGoogleUseCase>().call(params: NoParams());
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) => emit(AuthState(status: AuthStatus.emailVerified,user: r)),
//     );
//   }

//   // Log Out
//   Future<void> logOut(BuildContext context) async {
//     emit(AuthState(status: AuthStatus.loading));
//     final result = await serviceLocator<LogOutUseCase>().call(params: NoParams());
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) {
//         context.goNamed(AppRouteConstants.authRouteName);
//         emit(AuthState.initial());
//       } 
//     );
//   }

//   Future<void> getCurrentUser() async {
//   emit(AuthState(status: AuthStatus.unauthenticated));

//   final result = await serviceLocator<GetCurrentUserUseCase>().call(params: NoParams());

//   result.fold(
//     (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//     (userModel) {
//       final isEmailVerified = userModel.emailVerified;
//       final isAdminVerified = userModel.isVerified ?? false; // assumed to mean admin verified

//       log("Email verified: $isEmailVerified, Admin verified: $isAdminVerified");

//       AuthStatus status;

//       if (isEmailVerified && isAdminVerified) {
//         status = AuthStatus.adminVerified;
//       } else if (isEmailVerified) {
//         status = AuthStatus.emailVerified;
//       } else {
//         status = AuthStatus.authenticated;
//       }

//       emit(AuthState(
//         status: status,
//         user: userModel.toEntity(),
//       ));
//     },
//   );
// }


//   // Send Verification Email
//   Future<void> sendVerificationEmail() async {
//     final result = await serviceLocator<SendEmailVerificationUseCase>().call(params: NoParams());
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) => null,
//     );
//   }

//   // Resend Verification Email
//   Future<void> resendVerificationEmail() async {
//     final result = await serviceLocator<ResendVerificationEmailUseCase>().call(params: NoParams());
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) => null,
//     );
//   }

//   // Check Verification
//   Future<void> checkVerification(user) async {
//     final result = await serviceLocator<CheckVerificationUseCase>().call(params: user);
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (isVerified) {
//         final status = isVerified ? AuthStatus.emailVerified : AuthStatus.authenticated;
//         log("bloc updated ${isVerified.toString()}");
//         emit(AuthState(status: status));
//       },
//     );
//   }

//   // Reset Password
//   Future<void> resetPassword(String email) async {
//     final result = await serviceLocator<ResetPasswordUseCase>().call(params: email);
//     result.fold(
//       (l) => emit(ResetPasswordFailedState(status: AuthStatus.unauthenticated,message: l )),
//       (r) => emit(ResetPasswordSentState(status: AuthStatus.unauthenticated)),
//     );
//   }

//   // Register User (Optional - Post-SignUp processing)
//   Future<void> registerUser(UserEntity user) async {
//     final result = await serviceLocator<RegisterUserUseCase>().call(params: user);
//     result.fold(
//       (l) => emit(AuthState(status: AuthStatus.failure, message: l)),
//       (r) => emit(AuthState(status: AuthStatus.authenticated, user: r)),
//     );
//   }
// }

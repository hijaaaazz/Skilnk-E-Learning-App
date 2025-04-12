import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/data/auth/models/user_creation_req.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/domain/auth/entity/user.dart';
import 'package:tutor_app/domain/auth/usecases/check_verification.dart';
import 'package:tutor_app/domain/auth/usecases/get_user.dart';
import 'package:tutor_app/domain/auth/usecases/logout.dart';
import 'package:tutor_app/domain/auth/usecases/register.dart';
import 'package:tutor_app/domain/auth/usecases/resent_verification.dart';
import 'package:tutor_app/domain/auth/usecases/reset_pass.dart';
import 'package:tutor_app/domain/auth/usecases/signin.dart';
import 'package:tutor_app/domain/auth/usecases/signin_with_google.dart';
import 'package:tutor_app/domain/auth/usecases/signup.dart';
import 'package:tutor_app/domain/auth/usecases/verify.dart';
import 'package:tutor_app/service_locator.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  emailVerified,
  failure,
  loading,
}

class AuthStatusState {
  final AuthStatus status;
  final String? message;
  final UserEntity? user;

  AuthStatusState({required this.status, this.message, this.user});

  factory AuthStatusState.initial() =>
      AuthStatusState(status: AuthStatus.unauthenticated);
}
class ResetPasswordState extends AuthStatusState{
  ResetPasswordState({required super.status});
}
class ResetPasswordSentState extends ResetPasswordState{
  ResetPasswordSentState({required super.status});
}

class ResetPasswordFailedState extends ResetPasswordState {
  final String message;

  ResetPasswordFailedState({
    required super.status,
    required this.message,
  });

}

class AuthStatusCubit extends Cubit<AuthStatusState> {
  AuthStatusCubit() : super(AuthStatusState.initial());

  // Sign Up
  Future<void> signUp(UserCreationReq req) async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<SignupUseCase>().call(params: req);

    
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) {
        
        emit(AuthStatusState(status: AuthStatus.authenticated, user: r));
      }
    );
  }

  // Sign In
  Future<void> signIn(UserSignInReq req) async {
    log("SignIn");
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<SignInUseCase>().call(params: req);
    result.fold(
      (l) {
        log(l);
        emit(AuthStatusState(status: AuthStatus.failure, message: l));
      },
      (r) {
        log(r.toString());
        if(r!.emailVerified){
          emit(AuthStatusState(status: AuthStatus.emailVerified, user: r));
        }else{
          emit(AuthStatusState(status: AuthStatus.authenticated, user: r));
        }
        
      } 
    );
  }

  // Sign In With Google
  Future<void> signInWithGoogle() async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<SignInWithGoogleUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => emit(AuthStatusState(status: AuthStatus.emailVerified,user: r)),
    );
  }

  // Log Out
  Future<void> logOut() async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<LogOutUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => emit(AuthStatusState.initial()),
    );
  }

  // Get Current User
  Future<void> getCurrentUser() async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<GetCurrentUserUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (userModel) {
        final isVerified = userModel.emailVerified;
        log("bloc sttus $isVerified");
        emit(AuthStatusState(
          status: isVerified ? AuthStatus.emailVerified : AuthStatus.authenticated,
          user: userModel.toEntity(), // assume `toEntity()` exists
        ));
      },
    );
  }

  // Send Verification Email
  Future<void> sendVerificationEmail() async {
    final result = await serviceLocator<SendEmailVerificationUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => null,
    );
  }

  // Resend Verification Email
  Future<void> resendVerificationEmail() async {
    final result = await serviceLocator<ResendVerificationEmailUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => null,
    );
  }

  // Check Verification
  Future<void> checkVerification(user) async {
    final result = await serviceLocator<CheckVerificationUseCase>().call(params: user);
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (isVerified) {
        final status = isVerified ? AuthStatus.emailVerified : AuthStatus.authenticated;
        log("bloc updated ${isVerified.toString()}");
        emit(AuthStatusState(status: status));
      },
    );
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    final result = await serviceLocator<ResetPasswordUseCase>().call(params: email);
    result.fold(
      (l) => emit(ResetPasswordFailedState(status: AuthStatus.unauthenticated,message: l )),
      (r) => emit(ResetPasswordSentState(status: AuthStatus.unauthenticated)),
    );
  }

  // Register User (Optional - Post-SignUp processing)
  Future<void> registerUser(UserEntity user) async {
    final result = await serviceLocator<RegisterUserUseCase>().call(params: user);
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => emit(AuthStatusState(status: AuthStatus.authenticated, user: r)),
    );
  }
}

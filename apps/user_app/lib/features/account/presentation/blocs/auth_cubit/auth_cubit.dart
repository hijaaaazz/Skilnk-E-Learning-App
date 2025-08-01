import 'dart:developer';

import 'package:bloc/bloc.dart';
import  'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/account/domain/usecase/delete_account.dart';
import  'package:user_app/features/auth/data/models/user_creation_req.dart';
import  'package:user_app/features/auth/data/models/user_model.dart';
import  'package:user_app/features/auth/data/models/user_signin_model.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
import  'package:user_app/features/auth/domain/usecases/check_verification.dart';
import  'package:user_app/features/auth/domain/usecases/get_user.dart';
import  'package:user_app/features/auth/domain/usecases/logout.dart';
import  'package:user_app/features/auth/domain/usecases/register.dart';
import  'package:user_app/features/auth/domain/usecases/resent_verification.dart';
import  'package:user_app/features/auth/domain/usecases/reset_pass.dart';
import  'package:user_app/features/auth/domain/usecases/signin.dart';
import  'package:user_app/features/auth/domain/usecases/signin_with_google.dart';
import  'package:user_app/features/auth/domain/usecases/signup.dart';
import  'package:user_app/features/auth/domain/usecases/verify.dart';
import  'package:user_app/service_locator.dart';


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
  @override
  // ignore: overridden_fields
  final String message;

  ResetPasswordFailedState({
    required super.status,
    required this.message,
  });
}

class DeleteUserDataState extends AuthStatusState{
  DeleteUserDataState({required super.status});
}

class DeleteUserDtataLoadingState extends DeleteUserDataState{
  DeleteUserDtataLoadingState({required super.status});

}

class DeleteUserDataErrorState extends DeleteUserDataState{
  @override
  // ignore: overridden_fields
  final String message;
  DeleteUserDataErrorState({required super.status,required this.message});

}

class DeleteUserDataSuccessState extends DeleteUserDataState{
  DeleteUserDataSuccessState({required super.status});
  
}

class AuthStatusCubit extends Cubit<AuthStatusState> {
  AuthStatusCubit() : super(AuthStatusState.initial());



  Future<void> updateUserDp(String imagePath) async {
    emit(AuthStatusState(
          status: state.status,
          user: UserModel.fromEntity(state.user!).copyWith(image: imagePath).toEntity()
        ));
  }

  // Get Current User - Call this on app startup
  Future<void> getCurrentUser() async {
    // Already checking for current user, no need to emit loading state immediately
    final result = await serviceLocator<GetCurrentUserUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.unauthenticated)),
      (userModel) {
        final isVerified = userModel.emailVerified;
        emit(AuthStatusState(
          status: isVerified ? AuthStatus.emailVerified : AuthStatus.authenticated,
          user: userModel.toEntity(),
        ));
      },
    );
  }

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
        if(r.emailVerified){
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
      (r) => emit(AuthStatusState(status: AuthStatus.emailVerified, user: r)),
    );
  }

  // Log Out
  Future<void> logOut() async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<LogOutUseCase>().call(params: NoParams());
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => emit(AuthStatusState(status: AuthStatus.unauthenticated)),
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
    emit(AuthStatusState(status: AuthStatus.loading)); // Add loading state
    final result = await serviceLocator<ResetPasswordUseCase>().call(params: email);
    result.fold(
      (l) => emit(ResetPasswordFailedState(status: AuthStatus.unauthenticated, message: l)),
      (r) => emit(ResetPasswordSentState(status: AuthStatus.unauthenticated)),
    );
  }

  // Reset Password
  Future<void> deleteAccount(String id,String password) async {
    emit(DeleteUserDtataLoadingState(status: AuthStatus.loading)); // Add loading state
    final result = await serviceLocator<DeleteUserdataUserUseCase>().call(params: DeleteUserParams(id: id, password: password));
    result.fold(
      (l) => emit(DeleteUserDataErrorState(status: AuthStatus.emailVerified, message: l)),
      (r) => emit(DeleteUserDataSuccessState(status: AuthStatus.unauthenticated)),
    );
  }

  // Register User (Optional - Post-SignUp processing)
  Future<void> registerUser(UserEntity user) async {
    emit(AuthStatusState(status: AuthStatus.loading));
    final result = await serviceLocator<RegisterUserUseCase>().call(params: user);
    result.fold(
      (l) => emit(AuthStatusState(status: AuthStatus.failure, message: l)),
      (r) => emit(AuthStatusState(status: AuthStatus.authenticated, user: r)),
    );
  }
}
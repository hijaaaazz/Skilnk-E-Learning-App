
// auth_bloc.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/auth/domain/usecases/admin_verification_check.dart';
import 'package:tutor_app/features/auth/domain/usecases/check_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:tutor_app/features/auth/domain/usecases/get_user.dart';
import 'package:tutor_app/features/auth/domain/usecases/logout.dart';
import 'package:tutor_app/features/auth/domain/usecases/register.dart';
import 'package:tutor_app/features/auth/domain/usecases/resent_verification.dart';
import 'package:tutor_app/features/auth/domain/usecases/reset_pass.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin.dart';
import 'package:tutor_app/features/auth/domain/usecases/signin_with_google.dart';
import 'package:tutor_app/features/auth/domain/usecases/signup.dart';
import 'package:tutor_app/features/auth/domain/usecases/verify.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/service_locator.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<LogOutEvent>(_onLogOut);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<SendVerificationEmailEvent>(_onSendVerificationEmail);
    on<ResendVerificationEmailEvent>(_onResendVerificationEmail);
    on<CheckVerificationEvent>(_onCheckVerification);
    on<ResetPasswordEvent>(_onResetPassword);
    on<RegisterUserEvent>(_onRegisterUser);
    on<CheckIfUserVerifiedByAdminEvent>(_checkUserVerifiedByAdmin);
    on<DeleteAccountEvent>(_deleteAccount);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result =
        await serviceLocator<SignupUseCase>().call(params: event.request);

    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    log("SignIn");
    emit(const AuthLoading());
    final result =
        await serviceLocator<SignInUseCase>().call(params: event.request);
    
    result.fold(
      (failure) {
        log(failure);
        emit(AuthFailure(message: failure));
      },
      (user) {
        log(user.toString());
        if (user.emailVerified) {
          emit(AuthEmailVerified(user: user));
        } else {
          emit(AuthAuthenticated(user: user));
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result =
        await serviceLocator<SignInWithGoogleUseCase>().call(params: NoParams());
    
    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (user) => emit(AuthEmailVerified(user: user)),
    );
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result =
        await serviceLocator<LogOutUseCase>().call(params: NoParams());
        log(result.toString());
    result.fold(
      (failure) => emit(AuthFailure(message: failure,)),
      (_) {
        emit(const AuthInitial());
      },
    );
  }

 // Fixed _onGetCurrentUser method in AuthBloc
Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event, Emitter<AuthState> emit) async {
  // DON'T emit AuthInitial here - it causes null user issues
  // emit(const AuthInitial()); // Remove this line

  final result =
      await serviceLocator<GetCurrentUserUseCase>().call(params: NoParams());

  result.fold(
    (failure) => emit(AuthFailure(message: failure)),
    (userModel) {
      final isEmailVerified = userModel.emailVerified;
      final isAdminVerified = userModel.isVerified ?? false;

      log("Email verified: $isEmailVerified, Admin verified: $isAdminVerified");

      if (isEmailVerified && isAdminVerified) {
        emit(AuthAdminVerified(user: userModel.toEntity()));
      } else if (isEmailVerified) {
        emit(AuthEmailVerified(user: userModel.toEntity()));
      } else {
        emit(AuthAuthenticated(user: userModel.toEntity()));
      }
    },
  );
}
  Future<void> _onSendVerificationEmail(
      SendVerificationEmailEvent event, Emitter<AuthState> emit) async {
    final result = await serviceLocator<SendEmailVerificationUseCase>()
        .call(params: NoParams());
    
    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (_) => null, // Keep current state
    );
  }

  Future<void> _onResendVerificationEmail(
      ResendVerificationEmailEvent event, Emitter<AuthState> emit) async {
    final result = await serviceLocator<ResendVerificationEmailUseCase>()
        .call(params: NoParams());
    
    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (_) => null, // Keep current state
    );
  }

  Future<void> _onCheckVerification(
  CheckVerificationEvent event,
  Emitter<AuthState> emit,
) async {
  final stream = serviceLocator<CheckVerificationUseCase>().call(params: event.user);

  await emit.forEach<Either<String, bool>>(
    stream,
    onData: (result) {
      return result.fold(
        (failure) => AuthFailure(message: failure),
        (isVerified) {
          log("Email verified check: $isVerified");

          if (isVerified) {
            return AuthEmailVerified(user: event.user);
          } else {
            return AuthAuthenticated(user: event.user);
          }
        },
      );
    },
    onError: (error, stackTrace) {
      return AuthFailure(message: error.toString());
    },
  );
}


  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    final result = await serviceLocator<ResetPasswordUseCase>()
        .call(params: event.email);
    
    result.fold(
      (failure) => emit(ResetPasswordFailed(message: failure)),
      (_) => emit( ResetPasswordSent()),
    );
  }

  Future<void> _onRegisterUser(
      RegisterUserEvent event, Emitter<AuthState> emit) async {
    final result =
        await serviceLocator<RegisterUserUseCase>().call(params: event.user);
    
    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
  
Future<void> _checkUserVerifiedByAdmin(
  CheckIfUserVerifiedByAdminEvent event,
  Emitter<AuthState> emit,
) async {
  final stream = serviceLocator<CheckVerificationByAdminUseCase>().call(params: event.user);

  await emit.forEach<Either<String, bool>>(
    stream,
    onData: (result) {
      return result.fold(
        (failure) => AuthFailure(message: failure),
        (isVerified) {
          if (isVerified) {
            log("yrfvguyrfgvyuerfugfyuvbgyuhfgbyuh");
            return AuthAdminVerified(user: event.user);
          } else {
            return AuthEmailVerified(user: event.user);
          }
        },
      );
    },
    onError: (error, stackTrace) {
      return AuthFailure(message: error.toString());
    },
  );
}

Future<void> _deleteAccount(
  DeleteAccountEvent event,
  Emitter<AuthState> emit,
) async {
   final result = await serviceLocator<DeleteAccounttUseCase>()
        .call(params: event.params);
    
    result.fold(
      (failure) => emit(AuthFailure(message: failure)),
      (_) => emit(AuthInitial()), // Keep current state
    );
}


}
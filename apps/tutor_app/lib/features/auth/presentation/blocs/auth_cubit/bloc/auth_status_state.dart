
// auth_state.dart
import 'package:tutor_app/features/auth/domain/entity/user.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  emailVerified,
  adminVerified,
  failure,
  loading,
}

abstract class AuthState  {
  final AuthStatus status;
  final String? message;
  final UserEntity? user;

  const AuthState({
    required this.status,
    this.message,
    this.user,
  });
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(status: AuthStatus.unauthenticated);
}

class AuthLoading extends AuthState {
  const AuthLoading() : super(status: AuthStatus.loading);
}

class AuthFailure extends AuthState {
  const AuthFailure({required String message})
      : super(status: AuthStatus.failure, message: message);
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required UserEntity user})
      : super(status: AuthStatus.authenticated, user: user);
}

class AuthEmailVerified extends AuthState {
  const AuthEmailVerified({required UserEntity user})
      : super(status: AuthStatus.emailVerified, user: user);
}

class AuthAdminVerified extends AuthState {
  const AuthAdminVerified({required UserEntity user})
      : super(status: AuthStatus.adminVerified, user: user);
}

class ResetPasswordState extends AuthState {
  const ResetPasswordState()
      : super(status: AuthStatus.unauthenticated);
}

class ResetPasswordSent extends ResetPasswordState {}

class ResetPasswordFailed extends ResetPasswordState {
  @override
  final String message;

  const ResetPasswordFailed({required this.message})
      : super();
}

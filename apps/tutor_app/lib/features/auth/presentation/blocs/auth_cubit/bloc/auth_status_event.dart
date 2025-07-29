// auth_event.dart
import 'package:tutor_app/features/auth/data/models/delete_data_params.dart';
import 'package:tutor_app/features/auth/data/models/user_creation_req.dart';
import 'package:tutor_app/features/auth/data/models/user_signin_model.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';

abstract class AuthEvent  {
  const AuthEvent();

  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent {
  final UserCreationReq request;

  const SignUpEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class SignInEvent extends AuthEvent {
  final UserSignInReq request;

  const SignInEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class SignInWithGoogleEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {
}

class GetCurrentUserEvent extends AuthEvent {}

class SendVerificationEmailEvent extends AuthEvent {}

class ResendVerificationEmailEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {
  DeleteUserParams params;
  DeleteAccountEvent({required this.params});
}

class CheckVerificationEvent extends AuthEvent {
  final dynamic user;

  const CheckVerificationEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class RegisterUserEvent extends AuthEvent {
  final UserEntity user;

  const RegisterUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class CheckIfUserVerifiedByAdminEvent extends AuthEvent {
  final UserEntity user;

  const CheckIfUserVerifiedByAdminEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

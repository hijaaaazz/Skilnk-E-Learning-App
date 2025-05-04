// auth_event.dart
import 'package:flutter/material.dart';
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
  final BuildContext context;

  const LogOutEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class GetCurrentUserEvent extends AuthEvent {}

class SendVerificationEmailEvent extends AuthEvent {}

class ResendVerificationEmailEvent extends AuthEvent {}

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

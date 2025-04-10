part of 'user_management_bloc.dart';

@immutable
sealed class UserManagementState {}

final class UserInitial extends UserManagementState {}

final class UserLoading extends UserManagementState {}

final class UserLoaded extends UserManagementState {
  final UserEntity user;
  UserLoaded(this.user);
}

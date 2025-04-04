part of 'user_management_cubit.dart';

@immutable
sealed class UserManagementState {}


final class UsersLoading extends UserManagementState {}


final class UserLoadingSucces extends UserManagementState {
  final List<UserEntity> users;

  UserLoadingSucces({required this.users});
  
}

final class UserLoadingError extends UserManagementState {}




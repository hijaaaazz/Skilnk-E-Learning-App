part of 'user_management_cubit.dart';

@immutable
abstract class UserManagementState {
  final List<UserEntity> users;
  
  const UserManagementState({this.users = const []});
}

class UsersLoading extends UserManagementState {
  const UsersLoading({super.users});
}

class UserLoadingSucces extends UserManagementState {
  const UserLoadingSucces({required super.users});
}

class UserLoadingError extends UserManagementState {
  final String? error;
  
  const UserLoadingError({super.users, this.error});
}

class UserUpdationSuccess extends UserManagementState {
  const UserUpdationSuccess({required super.users});
}

class UserUpdationError extends UserManagementState {
  final String? error;
  
  const UserUpdationError({required super.users, this.error});
}

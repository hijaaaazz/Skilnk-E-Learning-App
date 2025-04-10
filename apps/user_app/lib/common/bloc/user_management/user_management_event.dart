part of 'user_management_bloc.dart';

@immutable
sealed class UserManagementEvent {}

final class LoadUserEvent extends UserManagementEvent {
  final UserEntity user;
  LoadUserEvent(this.user);
}

final class ClearUserEvent extends UserManagementEvent {}

import 'dart:developer';

import 'package:admin_app/features/users/data/models/user-update_params.dart';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/domain/usecases/get_users.dart';
import 'package:admin_app/features/users/domain/usecases/update_users.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit() : super(const UsersLoading());

  void displayUsers() async {
    emit(UsersLoading(users: state.users));
    
    var response = await serviceLocator<GetUsersUseCase>().call();
    response.fold(
      (error) {
        emit(UserLoadingError(users: state.users, error: error.toString()));
      },
      (data) {
        emit(UserLoadingSucces(users: data));
      },
    );
  }

  void toggleBlock(UserUpdateParams user) async {
  emit(UsersLoading(users: state.users)); // Optional: show loading if needed

  final response = await serviceLocator<ToggleUserBlockUseCase>().call(
    params: UserUpdateParams(userId: user.userId, toggle: user.toggle),
  );

  response.fold(
    (error) {
      // handle error, optionally emit error state
      // emit(UserLoadingError(users: state.users));
      log("Error: $error");
    },
    (updatedStatus) {
      final updatedUsers = state.users.map((u) {
        if (u.userId == user.userId) {
          return u.copyWith(isBlocked: updatedStatus);
        }
        return u;
      }).toList();

      emit(UserLoadingSucces(users: updatedUsers));
    },
  );
}

}

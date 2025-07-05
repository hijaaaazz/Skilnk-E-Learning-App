import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/domain/usecases/get_users.dart';
import 'package:admin_app/features/users/domain/usecases/update_users.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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

  // void updateUser(UserEntity user) async {
  //   try {
  //     // Optimistically update the UI
  //     final updatedUsers = state.users.map((u) {
  //       return u.userId == user.userId ? user : u;
  //     }).toList();
      
  //     emit(UserUpdationSuccess(users: updatedUsers));
      
  //     // Make the actual API call
  //     //final response = await serviceLocator<UpdateUserUseCase>().call(params: user);
      
  //     response.fold(
  //       (error) {
  //         // Revert the optimistic update on error
  //         emit(UserUpdationError(users: state.users, error: error.toString()));
  //         // Refresh the data
  //         displayUsers();
  //       },
  //       (success) {
  //         // Keep the updated state
  //         emit(UserUpdationSuccess(users: updatedUsers));
  //       },
  //     );
  //   } catch (e) {
  //     emit(UserUpdationError(users: state.users, error: e.toString()));
  //   }
  // }
}

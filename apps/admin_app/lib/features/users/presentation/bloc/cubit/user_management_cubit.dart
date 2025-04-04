import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/features/users/domain/usecases/get_users.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  UserManagementCubit() : super(UsersLoading());

  void displayUsers() async{
    var response = await serviceLocator<GetUsersUseCase>().call();
    response.fold(
      (error){
        emit(UserLoadingError());
      }, 
      (data){
        emit(UserLoadingSucces(users: data));
      });
  }
}

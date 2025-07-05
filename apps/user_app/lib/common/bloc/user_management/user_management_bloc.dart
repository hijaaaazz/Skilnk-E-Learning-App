import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';


part 'user_management_event.dart';
part 'user_management_state.dart';

class UserManagementBloc extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc() : super(UserInitial()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(UserLoaded(event.user));
    });

    on<ClearUserEvent>((event, emit) {
      emit(UserInitial());
    });
  }
}

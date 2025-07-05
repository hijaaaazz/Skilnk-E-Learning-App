
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';

class AuthUiCubit extends Cubit<AuthUiState> {
  AuthUiCubit() : super(AuthUiState.initial());

  void switchToForm(AuthFormType formType) {
    emit(AuthUiState(formType: formType));
  }
}

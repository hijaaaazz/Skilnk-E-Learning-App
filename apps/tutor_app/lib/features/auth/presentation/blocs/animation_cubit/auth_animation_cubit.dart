
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_state.dart';

class AuthUiCubit extends Cubit<AuthUiState> {
  AuthUiCubit() : super(AuthUiState.initial());

  void switchToForm(AuthFormType formType) {
    emit(AuthUiState(formType: formType));
  }
}

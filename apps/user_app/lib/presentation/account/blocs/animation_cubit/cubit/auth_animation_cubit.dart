
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/presentation/account/blocs/animation_cubit/cubit/auth_animation_state.dart';

class AuthUiCubit extends Cubit<AuthUiState> {
  AuthUiCubit() : super(AuthUiState.initial());

  void toggleAuthMode(bool isSignIn) {
    emit(state.copyWith(
      isInitialMode: false,
      formType: isSignIn ? AuthFormType.signIn : AuthFormType.signUp,
    ));
  }

  void goBackToInitial() {
    emit(state.copyWith(isInitialMode: true));
  }

  void toggleSignInSignUp() {
    final newFormType =
        state.formType == AuthFormType.signIn ? AuthFormType.signUp : AuthFormType.signIn;
    emit(state.copyWith(formType: newFormType));
  }
}

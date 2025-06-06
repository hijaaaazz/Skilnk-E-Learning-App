
enum AuthFormType {
  signIn,
  signUp,
  resetPass,
  initial,
}

class AuthUiState {
  final AuthFormType formType;

  AuthUiState({required this.formType});

  factory AuthUiState.initial() => AuthUiState(formType: AuthFormType.initial);
}

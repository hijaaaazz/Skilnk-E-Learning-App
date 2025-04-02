
enum AuthFormType { signIn, signUp }

class AuthUiState {
  final bool isInitialMode;
  final AuthFormType formType;

  AuthUiState({
    required this.isInitialMode,
    required this.formType,
  });

  factory AuthUiState.initial() => AuthUiState(
        isInitialMode: true,
        formType: AuthFormType.signIn,
      );

  AuthUiState copyWith({
    bool? isInitialMode,
    AuthFormType? formType,
  }) {
    return AuthUiState(
      isInitialMode: isInitialMode ?? this.isInitialMode,
      formType: formType ?? this.formType,
    );
  }
}

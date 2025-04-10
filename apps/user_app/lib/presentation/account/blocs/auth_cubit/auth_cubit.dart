import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthStatusState {
  final AuthStatus status;

  AuthStatusState({required this.status});

  factory AuthStatusState.initial() => AuthStatusState(status: AuthStatus.unauthenticated);
}

class AuthStatusCubit extends Cubit<AuthStatusState> {
  AuthStatusCubit() : super(AuthStatusState.initial());

  void login() {
    emit(AuthStatusState(status: AuthStatus.authenticated));
  }

  void logout() {
    emit(AuthStatusState(status: AuthStatus.unauthenticated));
  }
}

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { authenticated, unauthenticated, loading }

class AuthCubit extends Cubit<AuthState> {
  static const _storage = FlutterSecureStorage();

  AuthCubit() : super(AuthState.loading) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      emit(AuthState.authenticated);
    } else {
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> login(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    log("loggedIn");
    emit(AuthState.authenticated);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    emit(AuthState.unauthenticated);
  }
}

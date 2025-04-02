import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { authenticated, unauthenticated, loading }

class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage _storage;

  AuthCubit({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(),
        super(AuthState.loading) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        emit(AuthState.authenticated);
      } else {
        emit(AuthState.unauthenticated);
      }
    } catch (e) {
      log("Error checking login status: $e");
      emit(AuthState.unauthenticated);
    }
  }

  Future<void> login(String token) async {
    try {
      await _storage.write(key: 'auth_token', value: token);
      log("User logged in");
      emit(AuthState.authenticated);
    } catch (e) {
      log("Login error: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      log("User logged out");
      emit(AuthState.unauthenticated);
    } catch (e) {
      log("Logout error: $e");
    }
  }
}

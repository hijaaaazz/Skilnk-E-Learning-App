import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/presentation/account/pages/auth.dart';
import  'package:user_app/presentation/account/pages/profile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              switch (state) {
                case AuthState.authenticated:
                  return ProfileSection();
          
                case AuthState.unauthenticated:
                  return AuthenticationSection();
          
                case AuthState.loading:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}

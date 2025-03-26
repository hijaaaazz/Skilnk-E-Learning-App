import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/presentation/profile/cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {        },
        builder: (context, state) {
          switch (state) {
            case AuthState.authenticated:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Welcome User!"),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

            case AuthState.unauthenticated:
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().login("dummy_token");
                  },
                  child: const Text("Login"),
                ),
              );

            case AuthState.loading:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/auth/bloc/auth_cubit/auth_cubit.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/widgets/profile_header.dart';
import 'package:user_app/features/account/presentation/widgets/profile_infosection.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange.shade800,
        elevation: 0,
      ),
      body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
          } else if (state.status == AuthStatus.emailVerified) {
            final user = state.user!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(user: user),
                  ProfileInfoSection(user: user),
                ],
              ),
            );
          } else if (state.status == AuthStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.deepOrange.shade300),
                  const SizedBox(height: 16),
                  Text('Failed to load profile: ${state.message}', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_cubit.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_state.dart';
import 'package:tutor_app/features/account/presentation/widgets/profile_header.dart';
import 'package:tutor_app/features/account/presentation/widgets/profile_infosection.dart';
import 'dart:developer' as developer;

import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;


    final user = authState.user!;

    return BlocProvider(
      create: (context) => ProfileCubit()
        ..loadUserData(
          currentName: user.name,
          currentBio: user.bio ?? "",
          currentImageUrl: user.image ?? "",         // assuming this exists
          userCategories: user.categories ?? [],  // assuming it's a List<String>
        ),
      child: const ProfilePageContent(),
    );
  }
}


class ProfilePageContent extends StatefulWidget {
  const ProfilePageContent({super.key});

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
 // Fixed ProfilePageContent build method


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
    body: SingleChildScrollView(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileImageUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile image updated successfully!'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                if (ModalRoute.of(context)?.isCurrent == false) {
                  developer.log('Popping bottom sheet for ProfileImageUpdated');
                  Navigator.of(context).pop();
                }
              } else if (state is ProfileImageUpdateFailed) {
                if (ModalRoute.of(context)?.isCurrent == false) {
                  developer.log('Popping bottom sheet for ProfileImageUpdateFailed');
                  Navigator.of(context).pop();
                }
              } else if (state is ProfileNameUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Name updated successfully!'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.emailVerified && state.user != null) {
                final profileState = context.read<ProfileCubit>().state;
                if (profileState is! ProfileImageOptimisticUpdate &&
                    profileState is! ProfileImagePickerLoading &&
                    profileState is! ProfileImageUpdated &&
                    profileState is! ProfileImageShowMode) {
                  if (profileState.currentName != state.user!.name ||
                      profileState.currentImageUrl != state.user!.image) {
                    developer.log('Reinitializing ProfileCubit with name: ${state.user!.name}, image: ${state.user!.image}');
                    context.read<ProfileCubit>().initializeWithUserData(
                          name: state.user!.name,
                          imageUrl: state.user!.image,
                        );
                  }
                }
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Add null safety check
            if (state.user == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black87,
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                // Add refresh logic if needed
              },
              color: Colors.black87,
              child: Column(
                children: [
                  ProfileHeader(user: state.user!),
                  ProfileInfoSection(user: state.user!),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
}
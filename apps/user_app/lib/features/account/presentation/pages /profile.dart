import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../blocs/auth_cubit/auth_cubit.dart';
import '../blocs/cubit/profile_cubit.dart';
import '../blocs/cubit/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_infosection.dart';
import 'dart:developer' as developer;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePageContent();
  }
}

class ProfilePageContent extends StatefulWidget {
  const ProfilePageContent({super.key});

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthStatusCubit>().state;
      if (authState.status == AuthStatus.emailVerified && authState.user != null) {
        final userId = authState.user!.userId;
        context.read<ProfileCubit>().fetchRecentActivities(userId: userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                SnackBarUtils.showMinimalSnackBar(context,state.message);
                if (ModalRoute.of(context)?.isCurrent == false) {
                  developer.log('Popping bottom sheet for ProfileError');
                  Navigator.of(context).pop();
                }
              } else if (state is ProfileImageUpdated) {
                SnackBarUtils.showMinimalSnackBar(context,'Profile image updated successfully!');
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
                SnackBarUtils.showMinimalSnackBar(context,'Name updated successfully!');
              }
            },
          ),
          BlocListener<AuthStatusCubit, AuthStatusState>(
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
        child: BlocBuilder<AuthStatusCubit, AuthStatusState>(
          builder: (context, state) {
            if (state.status == AuthStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              );
            } else if (state.status == AuthStatus.emailVerified) {
              final user = state.user!;
              return RefreshIndicator(
                color: AppColors.primaryOrange,
                onRefresh: () async {
                  final userId = user.userId;
                  context.read<AuthStatusCubit>().getCurrentUser();
                  context.read<ProfileCubit>().fetchRecentActivities(userId: userId);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ProfileHeader(user: user),
                      ProfileInfoSection(user: user),
                    ],
                  ),
                ),
              );
            } else if (state.status == AuthStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      // ignore: deprecated_member_use
                      color: AppColors.primaryOrange.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Failed to load profile: ${state.message}',
                        style: TextStyle(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthStatusCubit>().getCurrentUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
      ),
    );
  }
}

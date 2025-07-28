// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/account/presentation/widgets/dialog.dart';
import 'package:tutor_app/features/account/presentation/widgets/option_tile.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state.status == AuthStatus.unauthenticated){
          context.goNamed(AppRouteConstants.authRouteName);
        }
      },
      child: Scaffold(
          appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  "Account",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                centerTitle: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.1),
                          Colors.grey.withOpacity(0.3),
                          Colors.grey.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          body: _buildAuthenticatedUI(context)
        ),
    );
  }

  Widget _buildAuthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          
          // Profile Section
          _buildSection(
            context,
            children: [
              buildOptionTile(
                context,
                "Profile",
                Icons.person_outline,
                onTap: () {
                  context.pushNamed(AppRouteConstants.profileRoutename);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Settings Section
          _buildSection(
            context,
            sectionTitle: "Settings",
            children: [
             
              buildOptionTile(
                context,
                "Change Passoword",
                Icons.security_outlined,
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
             
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Community & Support Section
          _buildSection(
            context,
            sectionTitle: "Community & Support",
            children: [
            
              buildDivider(),
              buildOptionTile(
                context,
                "Legal & Policies",
                Icons.gavel_outlined,
                onTap: () {
            context.pushNamed(AppRouteConstants.termsandconditions);
          },
              ),
               if(!kIsWeb)
               Column(
                children: [
                  buildDivider(),
                               
                  buildOptionTile(
                    context,
                    "Share this App",
                    Icons.share_outlined,
                    onTap: () {
                      Share.share(
                  'Check out the Skilnk App – a simple way to learn and grow! ',
                  subject: 'Skilnk – Learn with ease',
                              );
                    },
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Logout Button
          // Modern Logout Button with Confirmation Dialog
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => _showLogoutDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.shade50,
        foregroundColor: Colors.deepOrange.shade700,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.red.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 20, color: Colors.deepOrange),
          const SizedBox(width: 8),
          Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),

          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    String? sectionTitle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              sectionTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
 void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return CustomConfirmationDialog(
              title: 'Sign Out',
              description: 'Are you sure you want to sign out of your account?',
              icon: Icons.logout_rounded,
              iconColor: Colors.red.shade400,
              iconBackgroundColor: Colors.red.shade50,
              confirmText: 'Sign Out',
              confirmColor: Colors.red.shade500,
              isLoading: isLoading,
              onConfirm: () {
                context.read<AuthBloc>().add(LogOutEvent());
                // Navigation is handled in BlocListener in _buildAuthenticatedUI
              },
              onCancel: () => Navigator.of(dialogContext).pop(),
            );
          },
        );
      },
    );
  }


void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return CustomConfirmationDialog(
              title: 'Change Password',
              description: 'Are you sure you want to change your password?',
              icon: Icons.security_outlined,
              iconColor: Colors.blue.shade400,
              iconBackgroundColor: Colors.blue.shade50,
              confirmText: 'Change Password',
              confirmColor: Colors.blue.shade500,
              isLoading: isLoading,
              onConfirm: () {
                context.read<AuthBloc>().add(ResetPasswordEvent(email: context.read<AuthBloc>().state.user!.email));
                // Navigation or further handling can be added in BlocListener if needed
              },
              onCancel: () => Navigator.of(dialogContext).pop(),
            );
          },
        );
      },
    );
  }
}
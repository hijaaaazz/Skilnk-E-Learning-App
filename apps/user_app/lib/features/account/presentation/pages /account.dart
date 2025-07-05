import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/account/presentation/widgets/option_tile.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';
import  'package:user_app/presentation/account/widgets/unathenticated.dart';
import 'package:share_plus/share_plus.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(title:"Account"),
      body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, state) {
          if (state.status == AuthStatus.emailVerified) {
            return _buildAuthenticatedUI(context);
          } else {
            return buildUnauthenticatedUI(context);
          }
        },
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
                  context.pushNamed(AppRouteConstants.profileRouteName);
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
                "Change Password",
                Icons.security_outlined,
                onTap: () {
                  _showChangePasswordConfirmation(context);
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
              buildOptionTile(
                context,
                "Help & Support",
                Icons.help_outline,
                onTap: () {
                  context.pushNamed(AppRouteConstants.helpandsupportpage);
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "Legal & Policies",
                Icons.gavel_outlined,
                onTap: () {
                  context.pushNamed(AppRouteConstants.termsconditions);
                },
              ),
              buildDivider(),
             
              buildOptionTile(
  context,
  "Share this App",
  Icons.share_outlined,
  onTap: () {
    // ignore: deprecated_member_use
    Share.share(
      'Check out the Skilnk App – a simple way to learn and grow! 🚀\nDownload now: https://example.com/download',
      subject: 'Skilnk – Learn with ease',
    );
  },
),

            ],
          ),

          const SizedBox(height: 24),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmation(context);
                },
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: 'Sign Out',
        description: 'Are you sure you want to sign out of your account?',
        icon: Icons.logout_rounded,
        iconColor: Colors.red.shade400,
        iconBackgroundColor: Colors.red.shade50,
        confirmText: 'Sign Out',
        confirmColor: Colors.red.shade500,
        onConfirm: () {
          context.read<AuthStatusCubit>().logOut();
          context.pop();
        },
        onCancel: () {
          context.pop();
        },
        isLoading: context.watch<AuthStatusCubit>().state.status == AuthStatus.loading,
      ),
    ).then((_) {
      if (context.read<AuthStatusCubit>().state.status == AuthStatus.unauthenticated) {
        context.goNamed(AppRouteConstants.accountRouteName);
      }
    });
  }

  void _showChangePasswordConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: 'Change Password',
        description: '''Are you sure you want to change your password?
A mail will be sent to your email ID, and you will be logged out.
Are you sure you want to proceed?''',
        icon: Icons.security_outlined,
        iconColor: Colors.blue.shade400,
        iconBackgroundColor: Colors.blue.shade50,
        confirmText: 'Continue',
        confirmColor: Colors.blue.shade500,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<AuthStatusCubit>().resetPassword(context.read<AuthStatusCubit>().state.user!.email);
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }
}

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: confirmColor.withOpacity(0.6),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            confirmText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
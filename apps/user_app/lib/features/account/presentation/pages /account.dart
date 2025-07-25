// ignore_for_file: deprecated_member_use, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import 'package:user_app/features/account/presentation/widgets/login_suggession.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_route_constants.dart';
import '../blocs/auth_cubit/auth_cubit.dart';
import '../widgets/option_tile.dart';
import '../../../../presentation/account/widgets/app_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const SkilnkAppBar(title: "Account"),
      body: BlocListener<AuthStatusCubit, AuthStatusState>(
        listener: (context, state) {
          if (state is DeleteUserDataSuccessState) {
            SnackBarUtils.showMinimalSnackBar(context, 'Account deleted successfully.');
            Future.delayed(Duration.zero, () {
              context.goNamed(AppRouteConstants.accountRouteName);
            });
          } else if (state is DeleteUserDataErrorState) {
            SnackBarUtils.showMinimalSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<AuthStatusCubit, AuthStatusState>(
          builder: (context, state) {
            if (state.status == AuthStatus.emailVerified && state.user != null) {
              return _buildAuthenticatedUI(context);
            } else {
              return _buildUnauthenticatedUI(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
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
          _buildCommonSection(context),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteAccountConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                  foregroundColor: AppColors.primaryOrange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primaryOrange.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20, color: AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    const Text(
                      "Delete Account",
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
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                  foregroundColor: AppColors.primaryOrange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.primaryOrange.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20, color: AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    const Text(
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

  Widget _buildUnauthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const LoginSuggession(),
          ),
          const SizedBox(height: 20),
          _buildCommonSection(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCommonSection(BuildContext context) {
    return _buildSection(
      context,
      sectionTitle: "General",
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
            Share.share(
              'Check out the Skilnk App – a simple way to learn and grow! 🚀\nDownload now: https://apkpure.com/p/in.skilnk.user_app',
              subject: 'Skilnk – Learn with ease',
            );
          },
        ),
      ],
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
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
        iconColor: AppColors.primaryOrange,
        iconBackgroundColor: AppColors.primaryOrange.withOpacity(0.1),
        confirmText: 'Sign Out',
        confirmColor: AppColors.primaryOrange,
        onConfirm: () {
          context.read<AuthStatusCubit>().logOut();
          Navigator.of(dialogContext).pop();
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
        isLoading: context.read<AuthStatusCubit>().state.status == AuthStatus.loading,
      ),
    ).then((_) {
      if (context.read<AuthStatusCubit>().state.status == AuthStatus.unauthenticated) {
        context.goNamed(AppRouteConstants.accountRouteName);
      }
    });
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    final cubit = context.read<AuthStatusCubit>();

    if (cubit.state.user == null || cubit.state.user?.userId == null) {
      SnackBarUtils.showMinimalSnackBar(context, 'User data not available. Please log in again.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => CustomConfirmationDialogWithPassword(
        title: 'Delete Account',
        description: 'Enter your password to delete your account permanently.',
        icon: Icons.delete_forever,
        iconColor: Colors.red,
        iconBackgroundColor: Colors.red.withOpacity(0.1),
        confirmText: 'Delete',
        confirmColor: Colors.red,
        passwordController: _passwordController,
        onConfirm: () {
          final userId = cubit.state.user?.userId;
          final password = _passwordController.text.trim();
          if (userId != null && password.isNotEmpty) {
            cubit.deleteAccount(userId, password);
            Navigator.of(dialogContext).pop();
            _passwordController.clear();
          } else {
            SnackBarUtils.showMinimalSnackBar(context, 'Please enter a valid password.');
          }
        },
        onForgotPassword: () {
          _showChangePasswordConfirmation(context);
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          _passwordController.clear();
        },
        isLoading: cubit.state.status == AuthStatus.loading,
      ),
    );
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
        iconColor: AppColors.primaryBlue,
        iconBackgroundColor: AppColors.primaryBlue.withOpacity(0.1),
        confirmText: 'Continue',
        confirmColor: AppColors.primaryBlue,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          final user = context.read<AuthStatusCubit>().state.user;
          if (user != null) {
            context.read<AuthStatusCubit>().resetPassword(user.email);
          } else {
            SnackBarUtils.showMinimalSnackBar(context, 'User email not available.');
          }
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
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
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
                        ? const SizedBox(
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
}class CustomConfirmationDialogWithPassword extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String confirmText;
  final Color confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback onForgotPassword;
  final VoidCallback? onCancel;
  final bool isLoading;
  final TextEditingController passwordController;

  const CustomConfirmationDialogWithPassword({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.confirmText,
    required this.confirmColor,
    required this.onConfirm,
    required this.onForgotPassword,
    this.onCancel,
    this.isLoading = false,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300, width: 1.5)),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      disabledBackgroundColor: confirmColor.withOpacity(0.6),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                          )
                        : Text(confirmText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

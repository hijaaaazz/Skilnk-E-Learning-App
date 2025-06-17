import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/widgets/option_tile.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';
import 'package:user_app/presentation/account/widgets/unathenticated.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(title: "Account"),
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
                "Notifications",
                Icons.notifications_outlined,
                onTap: () {
                  // Handle notifications settings
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "Privacy & Security",
                Icons.security_outlined,
                onTap: () {
                  // Handle privacy settings
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "App Preferences",
                Icons.tune_outlined,
                onTap: () {
                  // Handle app preferences
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
                  // Handle help & support
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "Legal & Policies",
                Icons.gavel_outlined,
                onTap: () {
                  // Handle legal & policies
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "About App",
                Icons.info_outline,
                onTap: () {
                  // Handle about app
                },
              ),
              buildDivider(),
              buildOptionTile(
                context,
                "Share this App",
                Icons.share_outlined,
                onTap: () {
                  // Handle share app
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
                  context.read<AuthStatusCubit>().logOut();
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
                    Icon(Icons.logout, size: 20,color: Colors.deepOrange,),
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
}
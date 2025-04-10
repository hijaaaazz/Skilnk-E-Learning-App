import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_state.dart';
import 'package:user_app/common/widgets/app_bar.dart';
import 'package:user_app/common/widgets/basic_reactive_button.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/domain/auth/usecases/logout.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/presentation/account/widgets/login_suggession.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Account",),
      body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return _buildAuthenticatedUI(context);
          } else {
            return _buildUnauthenticatedUI(context);
          }
        },
      ),
    );
  }

  Widget _buildUnauthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Login suggestion at top
          Container(
            margin: const EdgeInsets.all(20),
            child: const LoginSuggession(),
          ),
          
          const SizedBox(height: 20),
          
          // General options section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "General",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 194, 45, 0),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // General options available without login
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
            child: Column(
              children: [
                
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Help & Support",
                  Icons.help_outline,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "About App",
                  Icons.info_outline,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Privacy Policy",
                  Icons.policy_outlined,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Terms of Service",
                  Icons.description_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // User profile header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 194, 45, 0).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 194, 45, 0),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "John Doe", // Replace with actual username
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "john.doe@example.com", // Replace with actual email
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  color: const Color.fromARGB(255, 194, 45, 0),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 194, 45, 0),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // Account options
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
            child: Column(
              children: [
                _buildOptionTile(
                  context,
                  "Profile",
                  Icons.person_outline,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Settings",
                  Icons.settings_outlined,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Notifications",
                  Icons.notifications_none_outlined,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Payments",
                  Icons.payment_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          
          // General section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "General",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 194, 45, 0),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          
          // General options
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
            child: Column(
              children: [
                _buildOptionTile(
                  context,
                  "Legal & Policies",
                  Icons.gavel_outlined,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Help & Support",
                  Icons.help_outline,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "About App",
                  Icons.info_outline,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildOptionTile(
                  context,
                  "Share this App",
                  Icons.share_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocProvider(
              create: (context) => ButtonStateCubit(),
              child: BlocListener<ButtonStateCubit, ButtonState>(
                listener: (context, state) {
                  if (state is ButtonSuccessState) {
                    context.read<AuthStatusCubit>().logout();
                  }
                },
                child: Builder(
                  builder: (context) {
                    return BasicReactiveButton(
                      title: "Log Out",
                      backgroundColor: const Color.fromARGB(255, 194, 45, 0),
                      textColor: Colors.white,
                      onPressed: () {
                        context.read<ButtonStateCubit>().execute(
                          usecase: LogOutUseCase(),
                          params: NoParams(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 194, 45, 0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 194, 45, 0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 56, // Aligns with the end of icon + spacing
    );
  }
}
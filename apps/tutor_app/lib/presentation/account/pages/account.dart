import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/app_bar.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/presentation/auth/blocs/auth_cubit/auth_cubit.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: "Account",),
      body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, state) {
          return _buildAuthenticatedUI(context);
        },
      ),
    );
  }


  Widget _buildAuthenticatedUI(BuildContext context) {
    return BlocBuilder<AuthStatusCubit,AuthStatusState>(
      builder: (context, state) {
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
                         Text(
                          state.user!.name, // Replace with actual username
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user!.email, // Replace with actual email
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
      
            
      
            TextButton(onPressed: ()async{
              
              await context.read<AuthStatusCubit>().logOut();
              context.goNamed(AppRouteConstants.authRouteName);
            }, child: Text("Logout")),
            
      
            const SizedBox(height: 30),
          ],
        ),
      );
      },
    
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
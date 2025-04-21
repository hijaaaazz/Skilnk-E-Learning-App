import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/widgets/option_tile.dart';
import 'package:user_app/presentation/account/widgets/unathenticated.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Account"),),
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

  
  }

  Widget _buildAuthenticatedUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // User profile header
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).primaryColor.withOpacity(0.1),
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(20),
          //       bottomRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           boxShadow: [
          //             BoxShadow(
          //               color: const Color.fromARGB(255, 194, 45, 0).withOpacity(0.3),
          //               spreadRadius: 1,
          //               blurRadius: 8,
          //               offset: const Offset(0, 3),
          //             ),
          //           ],
          //         ),
          //         child: CircleAvatar(
          //           radius: 40,
          //           backgroundColor: const Color.fromARGB(255, 194, 45, 0),
          //           child: const Icon(
          //             Icons.person,
          //             size: 40,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 16),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             const Text(
          //               "John Doe", // Replace with actual username
          //               style: TextStyle(
          //                 fontSize: 24,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             Text(
          //               "john.doe@example.com", // Replace with actual email
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color: Colors.grey[600],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.edit_outlined),
          //         color: const Color.fromARGB(255, 194, 45, 0),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ),

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
                buildOptionTile(
                  context,
                  "Profile",
                  Icons.person_outline,
                  onTap: () {
                    context.pushNamed(AppRouteConstants.profileRouteName);
                  },
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "Settings",
                  Icons.settings_outlined,
                  onTap: () {},
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "Notifications",
                  Icons.notifications_none_outlined,
                  onTap: () {},
                ),
                buildDivider(),
                buildOptionTile(
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
                buildOptionTile(
                  context,
                  "Legal & Policies",
                  Icons.gavel_outlined,
                  onTap: () {},
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "Help & Support",
                  Icons.help_outline,
                  onTap: () {},
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "About App",
                  Icons.info_outline,
                  onTap: () {},
                ),
                buildDivider(),
                buildOptionTile(
                  context,
                  "Share this App",
                  Icons.share_outlined,
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(onPressed: (){
              context.read<AuthStatusCubit>().logOut();
            }, child: Text("Logout"))
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

 
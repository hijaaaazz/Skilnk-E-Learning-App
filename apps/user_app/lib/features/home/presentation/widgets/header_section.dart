import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';

// Option 2: Separate SliverAppBar component to use with CustomScrollView
class HeaderSectionSliver extends StatelessWidget {
  const HeaderSectionSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit, AuthStatusState>(
      builder: (context, state) {
        return SliverAppBar(
          expandedHeight: 150,
          pinned: true,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.user?.name != null ? "Hi ${state.user!.name}" : 'Hi, Friend',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'What Would you like to learn Today?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const Text(
                    'Explore.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
          ),
        
        );
      },
    );
  }
}
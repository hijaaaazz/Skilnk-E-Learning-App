import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';

// Option 2: Separate SliverAppBar component to use with CustomScrollView
class HeaderSectionSliver extends StatelessWidget {
  const HeaderSectionSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthStatusCubit, AuthStatusState>(
      builder: (context, state) {
        return SliverAppBar(
          
          expandedHeight: MediaQuery.of(context).size.height * 0.15,
          pinned: true,
          backgroundColor: Colors.white,
          title: Text(
                        state.user?.name != null ? "Hi ${state.user!.name}" : 'Hi, Friend',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
          actions: [
            Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        child:Icon(FontAwesomeIcons.facebookMessenger,size: 16,)
                      ),
          ],
          
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  
                  const SizedBox(height: 10),
                  const Text(
                    'What Would you like to learn Today?',
                    style: TextStyle(
                      fontSize: 14,
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/presentation/auth/blocs/auth_cubit/auth_cubit.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(milliseconds: 4000));
  
    if (mounted) {
      final authCubit = context.read<AuthStatusCubit>();
      if (user != null) {
        context.pushNamed(AppRouteConstants.homeRouteName);
        authCubit.login(); 
      } else {
        context.pushNamed(AppRouteConstants.authRouteName);
        authCubit.logout(); 
      }

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(image: AssetImage("assets/animations/splash_animation.gif")),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/common/helpers/navigator.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/presentation/main_page/pages/landing.dart';

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
        authCubit.login(); // Firebase user is logged in
      } else {
        authCubit.logout(); // Firebase user is not logged in
      }

      context.pushNamed(AppRouteConstants.homeRouteName);
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

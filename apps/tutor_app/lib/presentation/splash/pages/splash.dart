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

  if (!mounted) return;

  final authCubit = context.read<AuthStatusCubit>();

  if (user != null) {
    if (!user.emailVerified) {
      // If user is logged in but email is not verified
      context.goNamed(AppRouteConstants.authRouteName);
    } else {
      // If user is logged in and verified, go to main/home page
      context.goNamed(AppRouteConstants.homeRouteName); // Change as per your main page
    }
  } else {
    // If user is not logged in
    context.goNamed(AppRouteConstants.authRouteName);
    authCubit.logout(); // Optionally reset any states
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

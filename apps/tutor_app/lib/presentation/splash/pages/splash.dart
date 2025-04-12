import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _handleSplashLogic();
  }

  void _handleSplashLogic() async {
    context.read<AuthStatusCubit>().getCurrentUser();
    await Future.delayed(const Duration(seconds: 4));

    final authState = context.read<AuthStatusCubit>().state;
    log("Auth state after splash: ${authState.status}");

    if (!mounted) return;

    if (authState.status == AuthStatus.emailVerified) {
      context.goNamed(AppRouteConstants.homeRouteName);
    } else {
      context.goNamed(AppRouteConstants.authRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: AssetImage("assets/animations/splash_animation.gif"),
        ),
      ),
    );
  }
}

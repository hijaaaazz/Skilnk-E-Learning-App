import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/helpers/navigator.dart';
import 'package:tutor_app/presentation/auth/bloc/auth_cubit/auth_cubit.dart';
import 'package:tutor_app/presentation/auth/pages/auth.dart';
import 'package:tutor_app/presentation/landing/pages/landing.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        final authState = context.read<AuthCubit>().state;

        if (authState == AuthState.authenticated) {
          AppNavigator.pushAndRemoveUntil(context, LandingPage());
        } else {
          AppNavigator.pushAndRemoveUntil(context, AuthenticationPage());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:Image(image: AssetImage("assets/animations/splash_animation.gif"))
      ),
    );
  }
}

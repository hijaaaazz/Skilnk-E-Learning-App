import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthStatusCubit>().getCurrentUser();
    _handleSplashLogic();
  }


   void _handleSplashLogic() async {
    await Future.delayed(const Duration(seconds: 4));
    context.goNamed(AppRouteConstants.homeRouteName);
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

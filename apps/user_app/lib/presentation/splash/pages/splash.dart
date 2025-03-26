import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/helpers/navigator.dart';
import 'package:user_app/presentation/landing/pages/landing.dart';
import 'package:user_app/presentation/account/cubit/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}



class _SplashPageState extends State<SplashPage> {
  

   @override
  void initState(){
    super.initState();
    context.read<AuthCubit>().checkLoginStatus();
    Future.delayed(const Duration(milliseconds: 4000), (){
      if(mounted){
        AppNavigator.push(context, LandingPage());
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

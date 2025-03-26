import 'package:flutter/material.dart';
import 'package:tutor_app/common/helpers/navigator.dart';
import 'package:tutor_app/presentation/landing/pages/landing.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}



class _SplashPageState extends State<SplashPage> {
  @override

   @override
  void initState(){
    super.initState();

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
      // body: Center(
      //   child:Image(image: AssetImage("assets/animations/splash_animation.gif"))
      // ),
    );
  }
}

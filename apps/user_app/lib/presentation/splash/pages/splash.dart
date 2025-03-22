import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late FlutterGifController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterGifController(vsync: this);
    _controller.animateTo(30, duration: const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:GifImage(
          image: AssetImage("assets/animations/splash_animation.gif"), 
          controller: _controller,
        ),
      ),
    );
  }
}

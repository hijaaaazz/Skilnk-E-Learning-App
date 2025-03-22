import 'package:flutter/material.dart';
import 'package:user_app/presentation/splash/pages/splash.dart';

void main() {
  runApp(const Skilnk());
}

class Skilnk extends StatelessWidget {
  const Skilnk({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
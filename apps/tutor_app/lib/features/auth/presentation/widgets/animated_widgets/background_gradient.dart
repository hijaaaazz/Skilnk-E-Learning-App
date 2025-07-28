import 'package:flutter/material.dart';

class BackGroundGradient extends StatelessWidget {
  const BackGroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height ,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(0, 255, 86, 34),
            Color.fromARGB(214, 255, 86, 34),
          ]
        )
      ),
    );
  }
}
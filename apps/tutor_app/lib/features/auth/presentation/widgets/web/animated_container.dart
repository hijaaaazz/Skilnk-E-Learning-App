// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:tutor_app/features/auth/presentation/widgets/web/web-clipper.dart';

class WebAnimatedContainer extends StatelessWidget {
  final bool isInitialMode;
  final Widget child;

  const WebAnimatedContainer({
    super.key,
    required this.isInitialMode,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Slanted container
        WebAnimatedSlantedClipper(
          isSlanted: !isInitialMode,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        
        // Handshake image
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: isInitialMode ? screenHeight * 0.15 : screenHeight * 0.08,
          right: isInitialMode ? screenWidth * 0.15 : screenWidth * 0.08,
          child: AnimatedOpacity(
            opacity: isInitialMode ? 1.0 : 0.3,
            duration: const Duration(milliseconds: 500),
            child: SizedBox(
              width: screenWidth * 0.15,
              height: screenHeight * 0.2,
              child: const Image(
                image: AssetImage("assets/images/handshake.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // Form content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
             
              child: Center(child: child),
            ),
          ),
        ),
      ],
    );
  }
}

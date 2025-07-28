// ignore_for_file: file_names

import 'package:flutter/material.dart';

class WebAnimatedSlantedClipper extends StatefulWidget {
  final bool isSlanted;
  final double screenWidth;
  final double screenHeight;

  const WebAnimatedSlantedClipper({
    super.key,
    required this.isSlanted,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<WebAnimatedSlantedClipper> createState() => _WebAnimatedSlantedClipperState();
}

class _WebAnimatedSlantedClipperState extends State<WebAnimatedSlantedClipper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSlanted) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 106, 60),
    
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

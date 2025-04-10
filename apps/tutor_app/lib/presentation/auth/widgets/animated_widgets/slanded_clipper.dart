import 'package:flutter/material.dart';

class AnimatedSlantedClipper extends StatefulWidget {
  final bool isSlanted;
  final double screenHeight;

  const AnimatedSlantedClipper({
    super.key,
    required this.isSlanted,
    required this.screenHeight,
  });

  @override
  State<AnimatedSlantedClipper> createState() => _AnimatedSlantedClipperState();
}

class _AnimatedSlantedClipperState extends State<AnimatedSlantedClipper>
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

    _animation = Tween<double>(begin: 0.2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSlanted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedSlantedClipper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSlanted) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipPath(
          clipper: SlantedClipper(angleFactor: _animation.value),
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: double.infinity,
        height: widget.isSlanted ? widget.screenHeight * 0.5 : widget.screenHeight * 0.75,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 106, 60),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.isSlanted? 20 : 0),
             )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SlantedClipper extends CustomClipper<Path> {
  final double angleFactor;

  SlantedClipper({required this.angleFactor});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * angleFactor); // Dynamic slant
    path.lineTo(size.width, 0); 
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant SlantedClipper oldClipper) {
    return oldClipper.angleFactor != angleFactor;
  }
}

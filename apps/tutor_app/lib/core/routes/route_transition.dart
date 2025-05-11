import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage createSlideTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);  // Start from right (horizontal slide)
      var end = Offset.zero;          // End at zero (normal position)
      var curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

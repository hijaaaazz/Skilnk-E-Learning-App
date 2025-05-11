import 'package:admin_app/core/routes/app_route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase Authentication instance
    final user = FirebaseAuth.instance.currentUser;

    // Check if there is a logged-in user
    if (user != null) {
      // User is logged in, navigate to the home screen
      Future.microtask(() {
        context.goNamed(AppRouteConstants.auth);
      });
    } else {
      // User is not logged in, navigate to the login screen
      Future.microtask(() {
        context.goNamed(AppRouteConstants.auth);
      });
    }

    return Scaffold(
      
      body: Center(child: CircularProgressIndicator()), // Loading until check is complete
    );
  }
}

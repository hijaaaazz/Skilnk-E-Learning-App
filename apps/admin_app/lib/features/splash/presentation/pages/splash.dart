import 'package:admin_app/features/auth/presentaion/pages/authentication.dart';
import 'package:admin_app/features/landing/presentation/pages/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      });
    } else {
      // User is not logged in, navigate to the login screen
      Future.microtask(() {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => AuthenticationPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Auth Check')),
      body: Center(child: CircularProgressIndicator()), // Loading until check is complete
    );
  }
}

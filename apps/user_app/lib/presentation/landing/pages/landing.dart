import 'package:flutter/material.dart';
import 'package:user_app/presentation/landing/widgets/navigation_bar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      body: Center(),
      bottomNavigationBar: AppNavigationBar(
        navItems: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore),label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.explore),label: "library")
        ],
      )
    );
  }
}
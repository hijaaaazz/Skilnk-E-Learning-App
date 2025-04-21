import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/features/main_page/presentation/widgets/navigation_bar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: buildBottomNavbar(navigationShell)
    );
  }
}

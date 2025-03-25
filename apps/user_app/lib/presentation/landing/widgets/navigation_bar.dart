import 'package:flutter/material.dart';


List<Color> NavBarColors = [
  Colors.black,
  Colors.orange,
  Colors.lime
];

// ignore: must_be_immutable
class AppNavigationBar extends StatelessWidget {

  List<BottomNavigationBarItem> navItems;

   AppNavigationBar({super.key, required this.navItems});

  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: navItems,
    );
  }
}
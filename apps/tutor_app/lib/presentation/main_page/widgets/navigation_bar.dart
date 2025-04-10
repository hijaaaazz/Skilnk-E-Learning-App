
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildBottomNavbar(StatefulNavigationShell navigationShell) {
  

  return NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        indicatorColor: Colors.amber,
        destinations: destinations.map(
          (destination) {
            return NavigationDestination(
              icon: destination.icon,
              label: destination.label,
            );
          },
        ).toList(),
      );
}

class Destination {
  const Destination({
    required this.label,
    required this.icon,
  });

  final String label;
  final Icon icon;
}

const destinations = [
  Destination(label: "Home", icon: Icon(Icons.home)),
  Destination(label: "Explore", icon: Icon(Icons.explore)),
  Destination(label: "Library", icon: Icon(Icons.library_books)),
  Destination(label: "Profile", icon: Icon(Icons.person)),
];
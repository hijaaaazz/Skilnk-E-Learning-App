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
    // Deep orange theming
    backgroundColor: Colors.white,
    indicatorColor: Colors.transparent,
    height: 65,
    shadowColor: Colors.black12,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    destinations: destinations.map(
      (destination) {
        return NavigationDestination(
          icon: Icon(
            destination.icon.icon,
            color: Colors.grey.shade600,
          ),
          selectedIcon: Icon(
            destination.icon.icon,
            color: Colors.deepOrange.shade800,
          ),
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
  Destination(label: "Dashboard", icon: Icon(Icons.grid_3x3)),
  Destination(label: "Courses", icon: Icon(Icons.library_books_outlined)),
  Destination(label: "Chats", icon: Icon(Icons.chat)),
  Destination(label: "Profile", icon: Icon(Icons.person_outline)),
];
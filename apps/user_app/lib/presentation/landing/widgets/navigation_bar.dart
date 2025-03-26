
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/landing/cubit/landing_navigation_cubit.dart';

Widget buildBottomNavbar(int currentIndex, BuildContext context) {
  // Define colors for each tab
  List<Color> colors = [
    const Color.fromARGB(255, 25, 29, 255),    // Home
    const Color.fromARGB(255, 255, 0, 0),   // Explore
    Colors.yellow, // Library
    Colors.orange  // Profile
  ];

  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) => context.read<LandingNavigationCubit>().updateIndex(index),
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: currentIndex == 0 ? colors[0] : Colors.grey),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore, color: currentIndex == 1 ? colors[1] : Colors.grey),
        label: "Explore",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books, color: currentIndex == 2 ? colors[2] : Colors.grey),
        label: "Library",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person, color: currentIndex == 3 ? colors[3] : Colors.grey),
        label: "Profile",
      ),
    ],
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Colors.black,
    type: BottomNavigationBarType.shifting,
    iconSize: 25,
  );
}

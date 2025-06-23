
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/landing/cubit/landing_navigation_cubit.dart';

Widget buildBottomNavbar(int currentIndex, BuildContext context) {
  

  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: (index) => context.read<LandingNavigationCubit>().updateIndex(index),
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: "Explore",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        label: "Library",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person,),
        label: "Profile",
      ),
    ],
    showSelectedLabels: false,
    showUnselectedLabels: false,
    fixedColor: Colors.deepOrange,
    backgroundColor: Colors.black,
    type: BottomNavigationBarType.shifting,
    iconSize: 25,
  );
}

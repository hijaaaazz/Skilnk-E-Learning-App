
  import 'package:admin_app/features/landing/presentation/bloc/landing_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Widget buildDrawer(int currentIndex, BuildContext context) {
  List<Map<String, dynamic>> drawerItems = [
    {"icon": Icons.dashboard, "title": "Dashboard", "color": Colors.blue},
    {"icon": Icons.menu_book, "title": "Courses", "color": Colors.green},
    {"icon": Icons.shopping_cart, "title": "Orders", "color": Colors.orange},
    {"icon": Icons.people, "title": "Manage Users", "color": Colors.purple},
    {"icon": Icons.person_add, "title": "Manage Instructors", "color": Colors.red},
    {"icon": Icons.settings, "title": "Settings", "color": Colors.grey},
  ];

  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blueGrey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_circle, size: 80, color: Colors.white),
              SizedBox(height: 10),
              Text("User Name", style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true, 
          itemCount: drawerItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(
                drawerItems[index]["icon"], 
                color: currentIndex == index ? drawerItems[index]["color"] : Colors.grey,
              ),
              title: Text(drawerItems[index]["title"]),
              onTap: () {
                context.read<LandingNavigationCubit>().updateIndex(index);
                Navigator.pop(context);
              },
            );
          },
        ),
      ],
    ),
  );

}

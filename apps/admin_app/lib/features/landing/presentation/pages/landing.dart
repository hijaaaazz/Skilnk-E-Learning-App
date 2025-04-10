import 'package:admin_app/features/courses/presentation/pages/courses.dart';
import 'package:admin_app/features/dashboard/presentation/pages/dashboard.dart';
import 'package:admin_app/features/instructors/presentation/pages/instructors.dart';
import 'package:admin_app/features/landing/presentation/bloc/landing_navigation_cubit.dart';
import 'package:admin_app/features/landing/presentation/widgets/navigation_bar.dart';
import 'package:admin_app/features/orders/presentation/pages/orders.dart';
import 'package:admin_app/features/profile/presentation/pages/profile.dart';
import 'package:admin_app/features/users/presentation/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static final List<Widget> pages = [
    DashboardPage(),
    CoursesPage(),
    OrdersPage(),
    UsersPage(),
    InstructorsPage(),
    ProfilePage()
  ];

  static final List<String> pageTitles = [
    "Dashboard",
    "Courses",
    "Orders",
    "Manage Users",
    "Manage Instructors",
    "Profile"
  ];

  static final List<List<Widget>> pageActions = [
    [IconButton(icon: Icon(Icons.refresh), onPressed: () {})], // Dashboard
    [IconButton(icon: Icon(Icons.search), onPressed: () {})], // Courses
    [IconButton(icon: Icon(Icons.filter_list), onPressed: () {})], // Orders
    [], // Users (No action)
    [], // Instructors (No action)
    [IconButton(icon: Icon(Icons.edit), onPressed: () {})], // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingNavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          appBar: AppBar(
            title: Text(pageTitles[currentIndex]), // Dynamic Title
            actions: pageActions[currentIndex], // Dynamic Actions
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          drawer: buildDrawer(currentIndex, context),
          body: pages[currentIndex],
        );
      },
    );
  }
}

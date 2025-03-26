import 'package:admin_app/presentation/courses/pages/courses.dart';
import 'package:admin_app/presentation/dashboard/pages/dashboard.dart';
import 'package:admin_app/presentation/instructors/pages/instructors.dart';
import 'package:admin_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:admin_app/presentation/landing/widgets/navigation_bar.dart';
import 'package:admin_app/presentation/orders/pages/orders.dart';
import 'package:admin_app/presentation/profile/pages/profile.dart';
import 'package:admin_app/presentation/users/pages/users.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingNavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Admin App"),
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
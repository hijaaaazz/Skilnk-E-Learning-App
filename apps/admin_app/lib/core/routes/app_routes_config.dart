import 'package:admin_app/features/courses/presentation/pages/categories.dart';
import 'package:admin_app/features/courses/presentation/pages/courses.dart';
import 'package:admin_app/features/dashboard/presentation/pages/dashboard.dart';
import 'package:admin_app/features/instructors/presentation/pages/instructors.dart';
import 'package:admin_app/features/orders/presentation/pages/orders.dart';
import 'package:admin_app/features/profile/presentation/pages/profile.dart';
import 'package:admin_app/features/users/presentation/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:admin_app/core/routes/app_route_constants.dart';
import 'package:admin_app/features/auth/presentaion/pages/authentication.dart';
import 'package:admin_app/features/landing/presentation/pages/landing.dart';
import 'package:admin_app/features/splash/presentation/pages/splash.dart';

class AppRoutes {
  final GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      /// Splash Page
      GoRoute(
        name: AppRouteConstants.splash,
        path: "/splash",
        pageBuilder: (context, state) => const MaterialPage(child: SplashPage()),
      ),

      /// Authentication Page
      GoRoute(
        name: AppRouteConstants.auth,
        path: "/auth",
        pageBuilder: (context, state) => const MaterialPage(child: AuthenticationPage()),
      ),

      /// Bottom Nav Pages (Stateful Shell)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LandingPage(navigationShell: navigationShell);
        },
        branches: [
          /// Dashboard Page
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/dashboard",
                name: AppRouteConstants.dashboard,
                builder: (context, state) => const DashboardPage (),
              ),
            ],
          ),

          /// Courses Page (with nested route)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/courses",
                name: AppRouteConstants.courses,
                builder: (context, state) => const CoursesPage(),
                routes: [
                  GoRoute(
                    path: "categories",
                    name: AppRouteConstants.coursecategory,
                    builder: (contex,state){
                      return const CategoryPage();
                    })
                ],
              ),
            ],
          ),

          
          
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/mentors",
                name: AppRouteConstants.instructors,
                builder: (context, state) => const InstructorsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/users",
                name: AppRouteConstants.users,
                builder: (context, state) => const UsersPage(),
              ),
            ],
          ),
          
        ],
      ),
    ],

    /// Error Page
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text("Error: Page not found"),
        ),
      ),
    ),
  );
}

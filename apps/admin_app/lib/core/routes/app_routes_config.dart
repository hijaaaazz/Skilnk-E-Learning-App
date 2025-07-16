import 'dart:async';

import 'package:admin_app/features/courses/presentation/pages/course_detailed_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:admin_app/features/courses/presentation/bloc/bloc/courses_bloc.dart';
import 'package:admin_app/features/courses/presentation/pages/categories.dart';
import 'package:admin_app/features/courses/presentation/pages/courses.dart';
import 'package:admin_app/features/dashboard/presentation/pages/dashboard.dart';
import 'package:admin_app/features/instructors/presentation/pages/instructors.dart';
import 'package:admin_app/features/users/presentation/pages/users.dart';
import 'package:admin_app/features/auth/presentaion/pages/authentication.dart';
import 'package:admin_app/features/landing/presentation/pages/landing.dart';
import 'package:admin_app/features/splash/presentation/pages/splash.dart';

import 'package:admin_app/core/routes/app_route_constants.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRoutes {
  final GoRouter router = GoRouter(
    initialLocation: "/splash",

    /// Refresh when auth state changes
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

    /// Redirect logic for auth protection
    redirect: (context, state) {
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final bool isAuthPage = state.fullPath == "/auth";
      final bool isSplash = state.fullPath == "/splash";

      if (!isLoggedIn && !isAuthPage && !isSplash) {
        return "/auth";
      }

      if (isLoggedIn && isAuthPage) {
        return "/dashboard";
      }

      return null;
    },

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

      /// Bottom Nav Pages (Protected Shell)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LandingPage(navigationShell: navigationShell);
        },
        branches: [
          /// Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/dashboard",
                name: AppRouteConstants.dashboard,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          /// Courses + Nested Category
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/courses",
                name: AppRouteConstants.courses,
                builder: (context, state) => BlocProvider(
                  create: (context) => CoursesBloc(),
                  child: const CoursesPage(),
                ),
                routes: [
                  GoRoute(
                    path: "/categories",
                    name: AppRouteConstants.coursecategory,
                    builder: (context, state) => const CategoryPage(),
                  ),
                  GoRoute(
                    path: "/course",
                    name: AppRouteConstants.course,
                    builder: (context, state) => const CourseDetailedPage(),
                  ),
                ],
              ),
            ],
          ),

          /// Instructors
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/mentors",
                name: AppRouteConstants.instructors,
                builder: (context, state) => const InstructorsPage(),
              ),
            ],
          ),

          /// Users
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

    /// Fallback Error Page
    errorPageBuilder: (context, state) => const MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text("Error: Page not found"),
        ),
      ),
    ),
  );
}

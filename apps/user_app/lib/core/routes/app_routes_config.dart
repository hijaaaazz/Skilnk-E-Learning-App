import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/presentation/account/pages/profile.dart';
import 'package:user_app/presentation/auth/pages/auth.dart';
import 'package:user_app/presentation/explore/pages/explore.dart';
import 'package:user_app/presentation/home/pages/home.dart';
import 'package:user_app/presentation/library/pages/library.dart';
import 'package:user_app/presentation/account/pages/account.dart';
import 'package:user_app/presentation/main_page/pages/landing.dart';
import 'package:user_app/presentation/splash/pages/splash.dart';

class AppRoutes {
  GoRouter router = GoRouter(
    initialLocation: "/splash"
    ,
    routes: [
      GoRoute(
        name: AppRouteConstants.splashRouteName,
        path: "/splash",
        pageBuilder: (context, state) {
          return MaterialPage(child: SplashPage());
        },
      ),

      GoRoute(
        name: AppRouteConstants.authRouteName,
        path: "/auth",
        pageBuilder: (context, state) {
          return MaterialPage(child: AuthenticationPage());
        },
      ),
      
      
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LandingPage(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/home",
                name: AppRouteConstants.homeRouteName,
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/explore",
                name: AppRouteConstants.exploreRouteName,
                builder: (context, state) => ExplorePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/library",
                name: AppRouteConstants.libraryRouteName,
                builder: (context, state) => LibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/account",
                name: AppRouteConstants.accountRouteName,
                builder: (context, state) => AccountPage(),
                routes: [
                  GoRoute(
                    path: "/profile",
                    name: AppRouteConstants.profileRouteName,
                    builder:(context, state) => ProfilePage(),
                    )
                ]
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text("Error: Page not found"),
          ),
        ),
      );
    },
  );
}
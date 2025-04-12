import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/domain/auth/entity/user.dart';
import 'package:tutor_app/presentation/account/pages/account.dart';
import 'package:tutor_app/presentation/auth/pages/auth.dart';
import 'package:tutor_app/presentation/auth/pages/email_verification_page.dart';
import 'package:tutor_app/presentation/auth/pages/verify_page.dart';
import 'package:tutor_app/presentation/main_page/pages/landing.dart';
import 'package:tutor_app/presentation/splash/pages/splash.dart';

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
        name: AppRouteConstants.emailVerificationRouteName,
        path: "/verify",
        pageBuilder: (context, state) {
          final user = (state.extra as UserEntity);
          return MaterialPage(child: VerifyPage(user: user,));
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
                path: "/dashboardpage",
                name: AppRouteConstants.homeRouteName,
                builder: (context, state) => DashBoardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/courses",
                name: AppRouteConstants.exploreRouteName,
                builder: (context, state) => CoursesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/chat",
                name: AppRouteConstants.libraryRouteName,
                builder: (context, state) => ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/profile",
                name: AppRouteConstants.profileRouteName,
                builder: (context, state) => AccountPage(),
                
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


class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

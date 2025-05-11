import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/core/routes/route_transition.dart';
import 'package:tutor_app/features/account/presentation/pages/account.dart';
import 'package:tutor_app/features/auth/presentation/pages/auth.dart';
import 'package:tutor_app/features/auth/presentation/pages/verify_page.dart';
import 'package:tutor_app/features/auth/presentation/pages/waiting_page.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/pages/add_course_warapper.dart';
import 'package:tutor_app/features/courses/presentation/pages/add_lesson.dart';
import 'package:tutor_app/features/courses/presentation/pages/courses.dart';
import 'package:tutor_app/features/courses/presentation/pages/advanced_info_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/curicullum_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/publish_couse.dart';
import 'package:tutor_app/features/courses/presentation/pages/basic_info_submition.dart';
import 'package:tutor_app/features/main_scaffold/presentation/pages/landing.dart';
import 'package:tutor_app/features/splash/presentation/pages/splash.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/courses/addnewcourse",
    routes: [
      // Authentication and Splash Routes
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
          return MaterialPage(child: VerifyPage());
        },
      ),
      GoRoute(
        name: AppRouteConstants.authRouteName,
        path: "/auth",
        pageBuilder: (context, state) {
          return MaterialPage(child: AuthenticationPage());
        },
      ),
      GoRoute(
        path: '/wait',
        name: AppRouteConstants.waitingRouteName,
        pageBuilder: (context, state) {
          return MaterialPage(child: WaitingPage());
        },
      ),
      
      // Course Creation Routes - Outside StatefulShellRoute so they don't show bottom navigation
      GoRoute(
        path: '/courses/addnewcourse',
        name: AppRouteConstants.addCourse,
        pageBuilder: (context, state) {
          // Create the cubit only when user navigates to add course flow
          
          return MaterialPage(
            child: BlocProvider(
              create: (_) => AddCourseCubit()..loadCourseOptions(),
              child: AddCourseWrapper(state: state),
            ),
          );
        },
        routes: [
          GoRoute(
            name: AppRouteConstants.addCourseBasicRouteName,
            path: 'basicinfo',
            pageBuilder: (context, state) {
              return createSlideTransitionPage(
                Builder(
                  builder: (context) {
                    // Access the parent route's cubit
                    final cubit = context.read<AddCourseCubit>();
                    return BlocProvider.value(
                      value: cubit,
                      child: const StepBasicInfo(),
                    );
                  },
                ),
              );
            },
          ),
         GoRoute(
          name: AppRouteConstants.addCourseAdvancedRouteName,
          path: 'advanced',
          pageBuilder: (context, state) {
            final addCourseCubit = state.extra as AddCourseCubit;

            return createSlideTransitionPage(
              BlocProvider.value(
                value: addCourseCubit,
                child: StepAdvancedInfo(),
              ),
            );
          },
        ),

          GoRoute(
            name: AppRouteConstants.addCourseCurriculumRouteName,
            path: 'curriculum',
            pageBuilder: (context, state) {
              final addCourseCubit = state.extra as AddCourseCubit;
              return createSlideTransitionPage(
                Builder(
                  builder: (context) {
                    // Access the parent route's cubit
                    return BlocProvider.value(
                      value: addCourseCubit,
                      child: StepCurriculum(),
                    );
                  },
                ),
              );
            },
            routes: [
              GoRoute(
            name: AppRouteConstants.addCourseaddlectureName,
            path: 'addlecture',
            pageBuilder: (context, state) {
              final addCourseCubit = state.extra as AddCourseCubit;
              return createSlideTransitionPage(
                Builder(
                  builder: (context) {
                    // Access the parent route's cubit
                    return BlocProvider.value(
                      value: addCourseCubit,
                      child: AddLecturePage(),
                    );
                  },
                ),
              );
            },
      
          ),
            ]
          ),
          GoRoute(
            name: AppRouteConstants.addCoursePublishRouteName,
            path: 'publish',
            pageBuilder: (context, state) {
              return createSlideTransitionPage(
                Builder(
                  builder: (context) {
                    // Access the parent route's cubit
                    final cubit = state.extra as AddCourseCubit;
                    return BlocProvider.value(
                      value: cubit,
                      child: StepPublish(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      
      // Main App Shell with Bottom Navigation
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
                builder: (context, state) => const CoursesPage(),
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
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
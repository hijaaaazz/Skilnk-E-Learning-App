import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/pages%20/account.dart';
import 'package:user_app/features/account/presentation/pages%20/profile.dart';
import 'package:user_app/features/auth/domain/entity/user.dart';
import 'package:user_app/features/auth/presentation/pages%20/auth.dart';
import 'package:user_app/features/auth/presentation/pages%20/info_submition.dart';
import 'package:user_app/features/auth/presentation/pages%20/verify_page.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/pages/explore.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/pages/course_detailed_page.dart';
import 'package:user_app/features/home/presentation/pages/course_enrolled_page.dart';
import 'package:user_app/features/home/presentation/pages/home.dart';
import 'package:user_app/features/home/presentation/pages/video_player_page.dart';
import 'package:user_app/features/library/presentation/pages/library.dart';
import 'package:user_app/features/main_page/presentation/pages/landing.dart';
import 'package:user_app/features/splash/presentation/pages/splash.dart';

class AppRoutes {
  GoRouter router = GoRouter(
    initialLocation: "/splash"
    ,
    routes: [
      
      
      GoRoute(path: '/course',
      name: AppRouteConstants.coursedetailsPaage,
      pageBuilder: (context, state) {
        final courseId = state.extra as String;
        return MaterialPage(child: BlocProvider(
          create: (context) => CourseCubit(),
          child: CourseDetailPage(
                  id: courseId,
                ),
        ));
      },),

      GoRoute(path: '/splash',
      name: AppRouteConstants.splashRouteName,
      pageBuilder: (context, state) {
        return MaterialPage(child: SplashPage());
      },),

      GoRoute(path: "/enrolled_course",
      name: AppRouteConstants.enrolledCoursedetailsPaage,
      pageBuilder: (context, state) {
        return MaterialPage(child: CourseProgressPage(courseId: 'uuhu',courseTitle: "uhuh",));
      },
      ),

      GoRoute(path: "/lecture",
      name: AppRouteConstants.lecturedetailsPaage,
      pageBuilder:(context,state){
         return MaterialPage(
        child:VideoPlayerPage(courseId: "",lectureId: "",) );
        }),

      GoRoute(
        name: AppRouteConstants.authRouteName,
        path: "/auth",
        pageBuilder: (context, state) {
          return MaterialPage(child: AuthenticationPage());
        },
      ),

      GoRoute(
        name: AppRouteConstants.verificationRouteName,
        path: "/verify",
        pageBuilder: (context, state) {
          final user = (state.extra as UserEntity);
          return MaterialPage(child: VerifyPage(user: user,));
        },
      ),
      GoRoute(
        name: AppRouteConstants.personalInfoSubmitingPageName,
        path: "/personalInfo",
        pageBuilder: (context, state) {
          
          return MaterialPage(child: InfoSubmitionPage());
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
                builder: (context, state) {
                  final query = state.extra as SearchParams?;
                  return BlocProvider(
                  
                  create: (context) => ExploreBloc(),
                  child: ExplorePage(queryParams: query,),
                );
                } 
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

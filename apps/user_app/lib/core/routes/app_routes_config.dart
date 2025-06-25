import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/cubit/profile_cubit.dart';
import 'package:user_app/features/account/presentation/pages%20/account.dart';
import 'package:user_app/features/account/presentation/pages%20/help_page.dart';
import 'package:user_app/features/account/presentation/pages%20/profile.dart';
import 'package:user_app/features/account/presentation/pages%20/terms.dart';
import 'package:user_app/features/auth/domain/entity/user.dart';
import 'package:user_app/features/auth/presentation/pages%20/auth.dart';
import 'package:user_app/features/auth/presentation/pages%20/info_submition.dart';
import 'package:user_app/features/auth/presentation/pages%20/verify_page.dart';
import 'package:user_app/features/chat/presentation/pages/chat.dart';
import 'package:user_app/features/chat/presentation/pages/chat_list.dart';
import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
import 'package:user_app/features/course_list/presentation/bloc/course_list_bloc.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/pages/explore.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/domain/entity/lecture_entity.dart';
import 'package:user_app/features/home/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_bloc.dart';
import 'package:user_app/features/home/presentation/pages/course_detailed_page.dart';
import 'package:user_app/features/home/presentation/pages/course_enrolled_page.dart';
import 'package:user_app/features/home/presentation/pages/home.dart';
import 'package:user_app/features/home/presentation/pages/mentor_details.dart';
import 'package:user_app/features/home/presentation/pages/video_player_page.dart';
import 'package:user_app/features/library/presentation/pages/library.dart';
import 'package:user_app/features/main_page/presentation/pages/landing.dart';
import 'package:user_app/features/splash/presentation/pages/splash.dart';
import 'package:user_app/features/course_list/presentation/pages/courselist.dart';

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
      },
     
      ),

      GoRoute(path: '/help',
      name: AppRouteConstants.helpandsupportpage,
      pageBuilder: (context, state) {
        return MaterialPage(child: HelpSupportPage(
              ));
      },
     
      ),

      GoRoute(path: '/legal',
      name: AppRouteConstants.termsconditions,
      pageBuilder: (context, state) {
        return MaterialPage(child: LegalDocumentsPage(
              ));
      },
     
      ),

      GoRoute(path: '/chat_list',
      name: AppRouteConstants.chatListPaage,
      pageBuilder: (context, state) {
        // ignore: unused_local_variable
        //final mentor = state.extra as MentorEntity;
        return MaterialPage(child: ChatListPage());
      },
     
      ),

      GoRoute(path: '/chat',
      name: AppRouteConstants.chatPaage,
      pageBuilder: (context, state) {
        final mentor = state.extra as MentorEntity;
        return MaterialPage(child: ChatPage(
          mentor: mentor,
              ));
      },
     
      ),

      GoRoute(path: '/mentor',
      name: AppRouteConstants.mentordetailsPaage,
      pageBuilder: (context, state) {
        final mentor = state.extra as MentorEntity;
        return MaterialPage(child: BlocProvider(
          create: (context) => CourseCubit(),
          child: MentorDetailsPage(
                  mentor: mentor,
                ),
        ));
      },),

      GoRoute(path: '/courses_list',
      name: AppRouteConstants.courselistPaage,
      pageBuilder: (context, state) {
        final args = state.extra as CourseListPageArgs;
        return MaterialPage(child: BlocProvider(
          create: (context) => CourseListBloc(),
          child: CourseList(
            args: args,
            
                ),
        ));
      },),

      GoRoute(path: '/splash',
      name: AppRouteConstants.splashRouteName,
      pageBuilder: (context, state) {
        return MaterialPage(child: SplashPage());
      },),

      GoRoute(
        path: "/enrolled_course",
        name: AppRouteConstants.enrolledCoursedetailsPaage,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          

          final courseId = extra?['courseId'] ?? '';
          final courseTitle = extra?['courseTitle'] ?? '';
          log(courseId);

          return MaterialPage(
            child: CourseProgressPage(
              courseId: courseId,
              courseTitle: courseTitle,
            ),
          );
        },
      ),

GoRoute(
  path: "/lecture",
  name: AppRouteConstants.lecturedetailsPaage,
  pageBuilder: (context, state) {
    final extras = state.extra as Map<String, dynamic>?;

    // ✅ Safely extract and cast
    final lectures = extras?['lectures'] as List<LectureProgressModel>?;
    final currentIndex = extras?['currentIndex'] as int? ?? 0;
    final bloc = extras?['bloc'] as CourseProgressBloc;
    final courseId = extras?['courseId'] as String;


    if (lectures == null || lectures.isEmpty) {
      return MaterialPage(
        child: Scaffold(
          body: Center(child: Text("Lecture data missing")),
        ),
      );
    }

    return MaterialPage(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => VideoPlayerBloc()),
          BlocProvider.value(value: bloc)
        ],
        child: VideoPlayerPage(
          lectures: lectures,
          currentIndex: currentIndex,
          courseId: courseId,
        ),
      ),
    );
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
                    builder:(context, state) => BlocProvider(
                      create: (context) => ProfileCubit(),
                      child: ProfilePage(),
                    ),
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

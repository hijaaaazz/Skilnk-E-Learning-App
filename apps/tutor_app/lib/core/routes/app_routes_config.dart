import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/core/routes/route_transition.dart';
import 'package:tutor_app/features/account/presentation/pages/account.dart';
import 'package:tutor_app/features/auth/presentation/pages/auth.dart';
import 'package:tutor_app/features/auth/presentation/pages/verify_page.dart';
import 'package:tutor_app/features/auth/presentation/pages/waiting_page.dart';
import 'package:tutor_app/features/courses/data/models/course_details_args.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/pages/add_course_warapper.dart';
import 'package:tutor_app/features/courses/presentation/pages/add_lesson.dart';
import 'package:tutor_app/features/courses/presentation/pages/course_detailed.dart';
import 'package:tutor_app/features/courses/presentation/pages/courses.dart';
import 'package:tutor_app/features/courses/presentation/pages/advanced_info_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/curicullum_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/full_screen_video_player.dart';
import 'package:tutor_app/features/courses/presentation/pages/lecture_detailed_page.dart';
import 'package:tutor_app/features/courses/presentation/pages/publish_couse.dart';
import 'package:tutor_app/features/courses/presentation/pages/basic_info_submition.dart';
import 'package:tutor_app/features/courses/presentation/widgets/pdf_view.dart';
import 'package:tutor_app/features/main_scaffold/presentation/pages/landing.dart';
import 'package:tutor_app/features/splash/presentation/pages/splash.dart';
import 'package:video_player/video_player.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/splash",
    routes: [
      // Authentication and Splash Routes

      GoRoute(
        name : AppRouteConstants.fullScreeenVideoPlayer,
        path: "/video",
        pageBuilder: (context,state){
          final controller = state.extra as VideoPlayerController;
          return MaterialPage(child: FullScreenVideoPlayer(controller: controller));
        }
      ),
      GoRoute(
        name : AppRouteConstants.lectureDetails,
        path: "/lecture",
        pageBuilder: (context,state){
          final lecture = state.extra as LectureEntity;
          return MaterialPage(child: LectureDetailScreen(lecture: lecture,));
        }
      ),
      GoRoute(
        name : AppRouteConstants.pdfViewer,
        path: "/pdf",
        pageBuilder: (context,state){
          final path = state.extra as String;
          return MaterialPage(child: ScreenPdfView(pathOrUrl: path));
        }
      ),
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
    final courseToEdit = state.extra as CourseEntity?;
    return MaterialPage(
      child: BlocProvider(
        create: (_) {
          final cubit = AddCourseCubit()..loadCourseOptions();
          if (courseToEdit != null) {
            cubit.courseToEditLoad(courseToEdit);
          }
          return cubit;
        },
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
                      child:  StepBasicInfo(),
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
                path: "/dashboard",
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
                routes: [
                  GoRoute(
                    path: "course_details",
                    name: AppRouteConstants.courseDetailesRouteName,
                    pageBuilder: (context, state) {
                      final args = state.extra as CourseDetailsArgs;
                      return MaterialPage(
                        child: BlocProvider.value(
                          value: args.bloc,
                          child: CourseDetailPage(courseId: args.courseId),
                        ),
                      );
                    },
                  ),

                ]
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
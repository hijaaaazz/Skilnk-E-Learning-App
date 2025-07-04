// Updated LibraryPage
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
import 'package:user_app/features/home/presentation/widgets/course_card.dart';
import 'package:user_app/features/library/presentation/bloc/library_bloc.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';
// Import your skeleton widget here
// import 'package:user_app/path/to/your/course_card_skeleton.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _isInitialized = false;

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_isInitialized) {
    final authState = context.read<AuthStatusCubit>().state;
    final user = authState.user;
    if (user != null) {
      final libraryBloc = context.read<LibraryBloc>();
      libraryBloc.add(LoadSavedCoursesEvent(userId: user.userId));
      libraryBloc.add(LoadEnrolledCoursesEvent(userId: user.userId));
    }
    _isInitialized = true;
  }
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(title: "Library"),
      body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
        builder: (context, authState) {
          if (authState.user == null) {
            return _buildSignUpPrompt();
          } else {
            return _buildLibraryContent(context, authState);
          }
        },
      ),
    );
  }

  Widget _buildSignUpPrompt() {
  return Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.library_books_rounded,
                size: 40,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Library Awaits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 73, 46, 38),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sign up to unlock your personal library\nand explore all available resources',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 88, 77, 74),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(AppRouteConstants.authRouteName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign Up Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildLibraryContent(BuildContext context, AuthStatusState authState) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = authState.user!.userId;
        final libraryBloc = context.read<LibraryBloc>();

        libraryBloc.add(RefreshSavedCoursesEvent(userId: userId));
        libraryBloc.add(RefreshEnrolledCoursesEvent(userId: userId)); // if needed
      },

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // My Courses Section
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                return _buildStaticSection(
                  title: 'My Courses',
                  ids: state is LibraryLoaded ? state.enrolledIds : [],
                  isLoaded: state is LibraryLoaded,
                  content: BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, courseState) {
                      if (courseState is LibraryLoaded) {
                        final myCourses = courseState.enrolledCourses.take(3).toList();
                        return _buildCourseContent(context, courses: myCourses, ids: courseState.enrolledIds, title: 'My Courses');
                      }
                      return _buildSkeletonContent();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Saved Courses Section
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, state) {
                return _buildStaticSection(
                  title: 'Saved Courses',
                  ids: state is LibraryLoaded ? state.savedIds : [],
                  isLoaded: state is LibraryLoaded,
                  content: BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, libraryState) {
                      if (libraryState is LibraryLoaded) {
                        return _buildCourseContent(context, courses: libraryState.savedCourses, ids: libraryState.savedIds, title: 'Saved Courses');
                      } else if (libraryState is LibraryError) {
                        return _buildErrorContent(
                          libraryState.message,
                          () => context.read<LibraryBloc>().add(
                            LoadSavedCoursesEvent(userId: authState.user!.userId),
                          ),
                        );
                      }
                      return _buildSkeletonContent();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            
          ],
        ),
      ),
    );
  }


  Widget _buildStaticSection({
    required String title,
    required Widget content,
    required List<String> ids,
    required bool isLoaded,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isLoaded)
              TextButton(
                onPressed: () {
                  context.pushNamed(
                    AppRouteConstants.courselistPaage,
                    extra: CourseListPageArgs(courseIds: ids, title: title),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SEE ALL',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
            else
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildCourseContent(
    BuildContext context, {
    required List courses,
    required List<String> ids,
    required String title,
  }) {
    if (courses.isEmpty) {
      return _buildEmptyState(title);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(courses.length, (index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CourseCard(
              course: course,
              isPartiallyVisible: index == courses.length - 1,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(2, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CourseCardSkeleton(), // Replace with your skeleton widget
          );
        }),
      ),
    );
  }

  Widget _buildErrorContent(String error, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Error loading courses',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: Colors.red.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No ${title.toLowerCase()} yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring courses to build your library',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
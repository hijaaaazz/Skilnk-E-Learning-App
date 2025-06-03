
// Updated LibraryPage
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/course_card.dart';
import 'package:user_app/features/library/presentation/bloc/library_bloc.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Sign Up to Access Your Library",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to sign-up
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
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
            // My Courses
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, courseState) {
                if (courseState is LibraryLoaded) {
                  final myCourses = courseState.enrolledCourses.take(3).toList();
                  return _buildCourseSection(context, title: 'My Courses', courses: myCourses);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),

            BlocBuilder<LibraryBloc, LibraryState>(
              builder: (context, libraryState) {
                if (libraryState is LibraryLoading) {
                  return _buildLoadingSection('Saved Courses');
                } else if (libraryState is LibraryLoaded) {
                  return _buildCourseSection(context, title: 'Saved Courses', courses: libraryState.savedCourses);
                } else if (libraryState is LibraryError) {
                  return _buildErrorSection(
                    'Saved Courses',
                    libraryState.message,
                    () => context.read<LibraryBloc>().add(
                      LoadSavedCoursesEvent(userId: authState.user!.userId),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),

            // Completed Courses
            // BlocBuilder<CourseBlocBloc, CourseBlocState>(
            //   builder: (context, courseState) {
            //     if (courseState is CourseBlocLoaded) {
            //       final completedCourses = courseState.courses.skip(5).take(1).toList();
            //       return _buildCourseSection(context, title: 'Completed Courses', courses: completedCourses);
            //     }
            //     return const SizedBox.shrink();
            //   },
            // ),
          ],
        ),
      ),
    );
  }


  Widget _buildCourseSection(
    BuildContext context, {
    required String title,
    required List courses,
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
            if (courses.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Navigate to full list view
                  // context.goNamed(routeName);
                },
                child: const Row(
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
              ),
          ],
        ),
        const SizedBox(height: 16),
        courses.isEmpty
            ? _buildEmptyState(title)
            : SingleChildScrollView(
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
              ),
      ],
    );
  }

  Widget _buildLoadingSection(String title) {
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
          ],
        ),
        const SizedBox(height: 16),
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildErrorSection(String title, String error, VoidCallback onRetry) {
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
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            children: [
              Text(
                'Error loading $title',
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
        ),
      ],
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
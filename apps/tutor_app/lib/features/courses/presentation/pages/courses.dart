import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/courses/data/models/course_details_args.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/courses_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();

    // Initialize courses if needed - defer to first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCoursesIfNeeded();
    });
  }

  // Extract method to initialize courses - can be called from other places too
  void _initializeCoursesIfNeeded() {
    if (!mounted) return;
    
    final state = context.read<CoursesBloc>().state;
    final courses = _getCoursesFromState(state);
    
    // Check if we need to load courses
    if (state is CoursesInitial || courses.isEmpty) {
      context.read<CoursesBloc>().add(LoadCourses(
        forceReload: false,
        tutorId: context.read<AuthBloc>().state.user!.tutorId
      ));
    }
  }

  // Method to navigate to course details with proper state handling
  Future<void> _navigateToCourseDetails(CoursePreview course) async {
    final bloc = context.read<CoursesBloc>();
    
    await context.pushNamed(
      AppRouteConstants.courseDetailesRouteName,
      extra: CourseDetailsArgs(
        bloc: bloc,
        courseId: course.id,
      )
    );
    
    // Make sure courses are still loaded when coming back
    if (mounted) {
      final state = context.read<CoursesBloc>().state;
      final courses = _getCoursesFromState(state);
      
      // If somehow we lost our courses, reload them
      if (courses.isEmpty) {
        _initializeCoursesIfNeeded();
      }
    }
  }

  // Method to navigate to add course screen
  Future<void> _navigateToAddCourse() async {
    final result = await context.pushNamed(AppRouteConstants.addCourse);
    if (result == true) {
      // Only refresh if course was added successfully
      if (mounted) {
        context.read<CoursesBloc>().add(RefreshCourses(
          tutorId: context.read<AuthBloc>().state.user!.tutorId
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  context.read<CoursesBloc>().add(LoadCourses(
                    forceReload: true,
                    tutorId: context.read<AuthBloc>().state.user!.tutorId,
                  ));
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        // Trigger LoadCourses once when state is CoursesInitial
        if (state is CoursesInitial) {
          context.read<CoursesBloc>().add(LoadCourses(
            tutorId: context.read<AuthBloc>().state.user!.tutorId,
          ));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("My Courses"),
          ),
          body: Builder(
            builder: (context) {
              if (state is CoursesInitial || (state is CoursesLoading && _getCoursesFromState(state).isEmpty)) {
                return const Center(child: CourseSkeletonLoading());
              } else {
                return _buildBody(context, state);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _navigateToAddCourse,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CoursesState state) {
    // Always wrap with RefreshIndicator for consistent pull-to-refresh
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CoursesBloc>().add(RefreshCourses(
          tutorId: context.read<AuthBloc>().state.user!.tutorId
        ));
        // Wait for the refresh to complete
        await Future.delayed(const Duration(seconds: 1));
      },
      child: _buildContentBasedOnState(context, state),
    );
  }
  
  Widget _buildContentBasedOnState(BuildContext context, CoursesState state) {
    if (state is CoursesError && _getCoursesFromState(state).isEmpty) {
      // Return a scrollable widget so RefreshIndicator works
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildErrorState(context, state.message)],
      );
    }
    
    // Get courses from the state
    final courses = _getCoursesFromState(state);
    
    if (courses.isEmpty) {
      // Return a scrollable widget so RefreshIndicator works
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildEmptyState(context)],
      );
    }

    // Main content - the courses grid
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.825,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            course: course,
            onTap: () => _navigateToCourseDetails(course),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CoursesBloc>().add(LoadCourses(
                  forceReload: true,
                  tutorId: context.read<AuthBloc>().state.user!.tutorId
                ));
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 16),
            const Text(
              'No courses found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first course by tapping the + button',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToAddCourse,
              icon: const Icon(Icons.add),
              label: const Text('Create Course'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get courses from any state
  List<CoursePreview> _getCoursesFromState(CoursesState state) {
    if (state is CoursesLoaded) {
      return state.courses;
    } else if (state is CoursesLoading) {
      return state.courses;
    } else if (state is CoursesError) {
      return state.courses ?? [];
    }
    return [];
  }
}

class CourseSkeletonLoading extends StatelessWidget {
  const CourseSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          // Make sure we can always scroll for pull to refresh
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.825,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6, // Show 6 skeleton items
          itemBuilder: (context, index) {
            return _buildCourseSkeleton();
          },
        ),
      ),
    );
  }

  Widget _buildCourseSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail placeholder
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Title placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Description placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 10,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Spacer(),
          // Price placeholder
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
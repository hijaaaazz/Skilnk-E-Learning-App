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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCoursesIfNeeded();
    });
  }

  void _initializeCoursesIfNeeded() {
    if (!mounted) return;
    
    final state = context.read<CoursesBloc>().state;
    final courses = _getCoursesFromState(state);
    
    if (state is CoursesInitial || courses.isEmpty) {
      context.read<CoursesBloc>().add(LoadCourses(
        forceReload: false,
        tutorId: context.read<AuthBloc>().state.user!.tutorId
      ));
    }
  }

  Future<void> _navigateToCourseDetails(CoursePreview course) async {
    final bloc = context.read<CoursesBloc>();
    
    await context.pushNamed(
      AppRouteConstants.courseDetailesRouteName,
      extra: CourseDetailsArgs(
        bloc: bloc,
        courseId: course.id,
      )
    );
    
    if (mounted) {
      final state = context.read<CoursesBloc>().state;
      final courses = _getCoursesFromState(state);
      
      if (courses.isEmpty) {
        _initializeCoursesIfNeeded();
      }
    }
  }

  Future<void> _navigateToAddCourse() async {
    final result = await context.pushNamed(AppRouteConstants.addCourse);
    if (result == true) {
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
              backgroundColor: const Color(0xFFFF5722),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
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
        if (state is CoursesInitial) {
          context.read<CoursesBloc>().add(LoadCourses(
            tutorId: context.read<AuthBloc>().state.user!.tutorId,
          ));
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "My Courses",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withOpacity(0.1),
                      Colors.grey.withOpacity(0.3),
                      Colors.grey.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Builder(
            builder: (context) {
              if (state is CoursesInitial || 
                  (state is CoursesLoading && _getCoursesFromState(state).isEmpty)) {
                return const CourseSkeletonLoading();
              } else {
                return _buildBody(context, state);
              }
            },
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5722).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: _navigateToAddCourse,
              backgroundColor: const Color(0xFFFF5722),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CoursesState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CoursesBloc>().add(RefreshCourses(
          tutorId: context.read<AuthBloc>().state.user!.tutorId
        ));
        await Future.delayed(const Duration(seconds: 1));
      },
      color: const Color(0xFFFF5722),
      backgroundColor: Colors.white,
      child: _buildContentBasedOnState(context, state),
    );
  }
  
  Widget _buildContentBasedOnState(BuildContext context, CoursesState state) {
    if (state is CoursesError && _getCoursesFromState(state).isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildErrorState(context, state.message)],
      );
    }
    
    final courses = _getCoursesFromState(state);
    
    if (courses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildEmptyState(context)],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Color(0xFFFF5722),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5722).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<CoursesBloc>().add(LoadCourses(
                    forceReload: true,
                    tutorId: context.read<AuthBloc>().state.user!.tutorId
                  ));
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 64,
                color: Color(0xFFFF5722),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No courses yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start your teaching journey by\ncreating your first course',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5722).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _navigateToAddCourse,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
          ),
          itemCount: 6,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (index) => 
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
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

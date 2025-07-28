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

    final authState = context.read<AuthBloc>().state;
    final user = authState.user;
    if (user == null) return;

    final state = context.read<CoursesBloc>().state;
    final courses = _getCoursesFromState(state);

    if (state is CoursesInitial || courses.isEmpty) {
      context.read<CoursesBloc>().add(LoadCourses(
        forceReload: false,
        tutorId: user.tutorId,
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
      ),
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
    if (result == true && mounted) {
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        context.read<CoursesBloc>().add(RefreshCourses(tutorId: user.tutorId));
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
                  final user = context.read<AuthBloc>().state.user;
                  if (user != null) {
                    context.read<CoursesBloc>().add(LoadCourses(
                      forceReload: true,
                      tutorId: user.tutorId,
                    ));
                  }
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth >= 600;
            return isWeb ? _buildWebLayout(context, state) : _buildMobileLayout(context, state);
          },
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, CoursesState state) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Courses",
          style: TextStyle(color: Colors.black87),
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
          if (state is CoursesInitial || (state is CoursesLoading && _getCoursesFromState(state).isEmpty)) {
            return const CourseSkeletonLoading();
          } else {
            return _buildBody(context, state, isWeb: false);
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
  }

  Widget _buildWebLayout(BuildContext context, CoursesState state) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          "My Courses",
          style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddCourse,
              icon: const Icon(Icons.add, size: 20),
              label: const Text("Add Course"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Builder(
            builder: (context) {
              if (state is CoursesInitial || (state is CoursesLoading && _getCoursesFromState(state).isEmpty)) {
                return const CourseSkeletonLoading(isWeb: true);
              } else {
                return _buildBody(context, state, isWeb: true);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CoursesState state, {required bool isWeb}) {
    return RefreshIndicator(
      onRefresh: () async {
        final user = context.read<AuthBloc>().state.user;
        if (user != null) {
          context.read<CoursesBloc>().add(RefreshCourses(tutorId: user.tutorId));
        }
        await Future.delayed(const Duration(seconds: 1));
      },
      color: const Color(0xFFFF5722),
      backgroundColor: Colors.white,
      child: _buildContentBasedOnState(context, state, isWeb: isWeb),
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, CoursesState state, {required bool isWeb}) {
    if (state is CoursesError && _getCoursesFromState(state).isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildErrorState(context, state.message, isWeb: isWeb)],
      );
    }

    final courses = _getCoursesFromState(state);

    if (courses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_buildEmptyState(context, isWeb: isWeb)],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        int crossAxisCount = isWeb ? (screenWidth > 900 ? 4 : 3) : 2;
        double childAspectRatio = isWeb ? 0.8 : 0.75;
        double padding = isWeb ? 32.0 : 20.0;
        double spacing = isWeb ? 24.0 : 16.0;

        return Padding(
          padding: EdgeInsets.all(padding),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
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
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message, {required bool isWeb}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(isWeb ? 48 : 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isWeb ? 32 : 24),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(isWeb ? 32 : 24),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: isWeb ? 64 : 48,
                color: const Color(0xFFFF5722),
              ),
            ),
            SizedBox(height: isWeb ? 32 : 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: isWeb ? 24 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isWeb ? 12 : 8),
            Text(
              message,
              style: TextStyle(
                fontSize: isWeb ? 16 : 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isWeb ? 48 : 32),
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
                  final user = context.read<AuthBloc>().state.user;
                  if (user != null) {
                    context.read<CoursesBloc>().add(LoadCourses(
                      forceReload: true,
                      tutorId: user.tutorId,
                    ));
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 32 : 24, vertical: isWeb ? 16 : 12),
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

  Widget _buildEmptyState(BuildContext context, {required bool isWeb}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(isWeb ? 48 : 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isWeb ? 48 : 32),
              decoration: BoxDecoration(
                color: const Color(0xFFFF5722).withOpacity(0.1),
                borderRadius: BorderRadius.circular(isWeb ? 48 : 32),
              ),
              child: Icon(
                Icons.school_outlined,
                size: isWeb ? 80 : 64,
                color: const Color(0xFFFF5722),
              ),
            ),
            SizedBox(height: isWeb ? 48 : 32),
            Text(
              'No courses yet',
              style: TextStyle(
                fontSize: isWeb ? 28 : 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isWeb ? 16 : 12),
            Text(
              'Start your teaching journey by\ncreating your first course',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWeb ? 18 : 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: isWeb ? 64 : 40),
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
                  padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 32, vertical: isWeb ? 20 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: TextStyle(
                    fontSize: isWeb ? 18 : 16,
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
  final bool isWeb;

  const CourseSkeletonLoading({super.key, this.isWeb = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 32.0 : 20.0),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? (MediaQuery.of(context).size.width > 900 ? 4 : 3) : 2,
            childAspectRatio: isWeb ? 0.8 : 0.75,
            crossAxisSpacing: isWeb ? 24.0 : 16.0,
            mainAxisSpacing: isWeb ? 24.0 : 20.0,
          ),
          itemCount: isWeb ? 8 : 6,
          itemBuilder: (context, index) {
            return _buildCourseSkeleton(isWeb: isWeb);
          },
        ),
      ),
    );
  }

  Widget _buildCourseSkeleton({required bool isWeb}) {
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
            height: isWeb ? 160 : 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isWeb ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: isWeb ? 20 : 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: isWeb ? 12 : 8),
                Container(
                  height: isWeb ? 16 : 12,
                  width: isWeb ? 100 : 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: isWeb ? 16 : 12),
                Row(
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: isWeb ? 16 : 12,
                      width: isWeb ? 16 : 12,
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_event.dart';
import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_state.dart';
import 'dart:developer';
import '../widgets/lecture_card.dart';
import '../widgets/progress_overview_card.dart';

class CourseProgressPage extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseProgressPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseProgressBloc(
      )..add(LoadCourseProgressEvent(
        courseId: courseId,
        userId: context.read<AuthStatusCubit>().state.user!.userId,
      )),
      child: CourseProgressView(
        courseId: courseId,
        courseTitle: courseTitle,
      ),
    );
  }
}

class CourseProgressView extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseProgressView({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  void _onLectureTap(BuildContext context, List<LectureProgressModel> lectures, int currentIndex) {
  if (lectures[currentIndex].isLocked) {
    _showLockedLectureMessage(context);
    return;
  }

  try {
    final bloc = context.read<CourseProgressBloc>();

    if (courseId != null) {
      log("[_onLectureTap] Navigating with courseId: $courseId");

      context.pushNamed(
        AppRouteConstants.lecturedetailsPaage,
        extra: {
          'lectures': lectures,
          'currentIndex': currentIndex,
          'bloc': bloc,
          'courseId': courseId, // ✅ fixed key
        },
      ).then((result) {
        if (result == true) {
          // Refresh course progress after returning
          final userId = context.read<AuthStatusCubit>().state.user?.userId;
          if (userId != null) {
            context.read<CourseProgressBloc>().add(
              RefreshCourseProgressEvent(
                courseId: courseId,
                userId: userId,
              ),
            );
          }
        }
      });
    } else {
      _showErrorMessage(context, 'Course ID is missing');
    }
  } catch (e) {
    log('[_onLectureTap] Error: $e');
    _showErrorMessage(context, 'Failed to open lecture');
  }
}


  void _showLockedLectureMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete previous lectures to unlock this one'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocConsumer<CourseProgressBloc, CourseProgressState>(
        listener: (context, state) {
          if (state is CourseProgressError) {
            _showErrorMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is CourseProgressLoading) {
            return _buildLoadingState();
          } else if (state is CourseProgressLoaded) {
            return _buildContent(context, state.courseProgress);
          } else if (state is CourseProgressError) {
            return _buildErrorState(context, state.message);
          }
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFFF6636),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading course progress...',
            style: TextStyle(
              color: Color(0xFF545454),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFFF6636),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF545454),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CourseProgressBloc>().add(
                LoadCourseProgressEvent(
                  courseId: courseId,
                  userId: context.read<AuthStatusCubit>().state.user!.userId,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6636),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CourseProgressModel courseProgress) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, courseProgress),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProgressOverviewCard(courseProgress: courseProgress),
                const SizedBox(height: 24),
                _buildLecturesSection(context, courseProgress),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CourseProgressModel courseProgress) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFFF6636),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            // Show course options
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          courseTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 60),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFF6636),
                const Color(0xFFFF6636).withOpacity(0.9),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  courseProgress.courseThumbnail,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFFF6636),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      const Color(0xFFFF6636).withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLecturesSection(BuildContext context, CourseProgressModel courseProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lectures',
          style: TextStyle(
            color: Color(0xFF202244),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ...courseProgress.lectures.asMap().entries.map((entry) {
  final index = entry.key;
  final lecture = entry.value;

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: LectureCard(
      lecture: lecture,
      onTap: () => _onLectureTap(context, courseProgress.lectures, index),
    ),
  );
}),

      ],
    );
  }
}
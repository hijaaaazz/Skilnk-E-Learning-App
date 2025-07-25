// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import '../../../../core/routes/app_route_constants.dart';
import '../../../account/presentation/blocs/auth_cubit/auth_cubit.dart';
import '../../data/models/course_progress.dart';
import '../../data/models/lecture_progress_model.dart';
import '../bloc/progress_bloc/course_progress_bloc.dart';
import '../bloc/progress_bloc/course_progress_event.dart';
import '../bloc/progress_bloc/course_progress_state.dart';
import 'dart:developer';

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
      create: (context) => CourseProgressBloc()
        ..add(LoadCourseProgressEvent(
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
            'courseId': courseId,
          },
        ).then((result) {
          if (result == true) {
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
    SnackBarUtils.showMinimalSnackBar(context,'Complete previous lectures to unlock this one');
  }

  void _showErrorMessage(BuildContext context, String message) {
    SnackBarUtils.showMinimalSnackBar(context,message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocConsumer<CourseProgressBloc, CourseProgressState>(
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
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFFF6B35),
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading course progress...',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CourseProgressModel courseProgress) {
    return Column(
      children: [
        // Minimal Header (matching home page style)
        _buildMinimalHeader(context, courseProgress),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Overview Card
                _buildProgressCard(courseProgress),
                const SizedBox(height: 32),
                
                // Lectures Section
                _buildLecturesSection(context, courseProgress),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalHeader(BuildContext context, CourseProgressModel courseProgress) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (matching home page)
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF1A1A1A),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  courseTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Track your learning progress.\nKeep going!",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(CourseProgressModel courseProgress) {
    final progressPercentage = courseProgress.completedLectures / courseProgress.lectures.length;
    Duration totalWatched = courseProgress.lectures
    .map((l) => l.watchedDuration)
    .fold(Duration.zero, (a, b) => a + b);

String formattedTime = [
  if (totalWatched.inHours > 0) '${totalWatched.inHours}h',
  '${totalWatched.inMinutes.remainder(60)}m',
  '${totalWatched.inSeconds.remainder(60)}s',
].join(' ');
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Your Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                "${(progressPercentage * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "${courseProgress.completedLectures} of ${courseProgress.lectures.length} lectures completed",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressPercentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
      "Total time: $formattedTime",
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.9),
      ),
    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLecturesSection(BuildContext context, CourseProgressModel courseProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lectures',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Text(
              '${courseProgress.lectures.length} lectures',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        ...courseProgress.lectures.asMap().entries.map((entry) {
          final index = entry.key;
          final lecture = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MinimalLectureCard(
              lecture: lecture,
              lectureNumber: index + 1,
              onTap: () => _onLectureTap(context, courseProgress.lectures, index),
            ),
          );
        }),
      ],
    );
  }
}

class MinimalLectureCard extends StatelessWidget {
  final LectureProgressModel lecture;
  final int lectureNumber;
  final VoidCallback onTap;

  const MinimalLectureCard({
    super.key,
    required this.lecture,
    required this.lectureNumber,
    required this.onTap,
  });

  

  @override
  Widget build(BuildContext context) {
    Duration duration = lecture.lecture.duration;
    String formattedDuration = [
  duration.inHours.toString().padLeft(2, '0'),
  duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
  duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
].join(':');
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: lecture.isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Lecture Number/Status
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _buildStatusIcon(),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lecture.lecture.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: lecture.isLocked 
                              ? const Color(0xFF999999)
                              : const Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: const Color(0xFF666666).withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDuration,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF666666).withOpacity(0.7),
                            ),
                          ),
                          if (lecture.isCompleted) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow or Lock Icon
                Icon(
                  lecture.isLocked ? Icons.lock : Icons.arrow_forward_ios,
                  size: 16,
                  color: lecture.isLocked 
                      ? const Color(0xFF999999)
                      : const Color(0xFF666666),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (lecture.isCompleted) {
      return const Color(0xFF4CAF50); // Green
    } else if (lecture.isLocked) {
      return const Color(0xFF999999); // Gray
    } else {
      return const Color(0xFFFF6B35); // Orange
    }
  }

  Widget _buildStatusIcon() {
    if (lecture.isCompleted) {
      return const Icon(
        Icons.check_circle,
        color: Color(0xFF4CAF50),
        size: 24,
      );
    } else if (lecture.isLocked) {
      return const Icon(
        Icons.lock,
        color: Color(0xFF999999),
        size: 20,
      );
    } else {
      return Text(
        lectureNumber.toString(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFF6B35),
        ),
      );
    }
  }
}

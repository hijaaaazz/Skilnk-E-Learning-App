import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'dart:developer';
import '../widgets/lecture_card.dart';
import '../widgets/progress_overview_card.dart';

class CourseProgressPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const CourseProgressPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseProgressPage> createState() => _CourseProgressPageState();
}

class _CourseProgressPageState extends State<CourseProgressPage> {
  late CourseProgressModel courseProgress;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourseProgress();
  }

  void _loadCourseProgress() {
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        courseProgress = _createDummyCourseProgress();
        isLoading = false;
      });
    });
  }

  CourseProgressModel _createDummyCourseProgress() {
    final lectures = [
      LectureProgressModel(
        id: '1',
        title: 'Introduction to Flutter Development',
        duration: const Duration(minutes: 15),
        watchedDuration: const Duration(minutes: 15),
        isCompleted: true,
        isLocked: false,
        videoUrl: 'dummy_url_1',
        lectureNumber: 1,
      ),
      LectureProgressModel(
        id: '2',
        title: 'Setting up Development Environment',
        duration: const Duration(minutes: 20),
        watchedDuration: const Duration(minutes: 12),
        isCompleted: false,
        isLocked: false,
        videoUrl: 'dummy_url_2',
        lectureNumber: 2,
      ),
      LectureProgressModel(
        id: '3',
        title: 'Understanding Widgets and Layouts',
        duration: const Duration(minutes: 25),
        watchedDuration: const Duration(minutes: 8),
        isCompleted: false,
        isLocked: false,
        videoUrl: 'dummy_url_3',
        lectureNumber: 3,
      ),
      LectureProgressModel(
        id: '4',
        title: 'State Management Basics',
        duration: const Duration(minutes: 30),
        watchedDuration: Duration.zero,
        isCompleted: false,
        isLocked: false,
        videoUrl: 'dummy_url_4',
        lectureNumber: 4,
      ),
      LectureProgressModel(
        id: '5',
        title: 'Advanced State Management',
        duration: const Duration(minutes: 35),
        watchedDuration: Duration.zero,
        isCompleted: false,
        isLocked: true,
        videoUrl: 'dummy_url_5',
        lectureNumber: 5,
      ),
      LectureProgressModel(
        id: '6',
        title: 'Building Your First App',
        duration: const Duration(minutes: 40),
        watchedDuration: Duration.zero,
        isCompleted: false,
        isLocked: true,
        videoUrl: 'dummy_url_6',
        lectureNumber: 6,
      ),
    ];

    final completedCount = lectures.where((l) => l.isCompleted).length;
    final overallProgress = completedCount / lectures.length;

    return CourseProgressModel(
      id: "",
      userId: "",
      enrolledAt: DateTime(2000),
      lastAccessedAt:DateTime(2000),
      courseId: widget.courseId,
      courseTitle: widget.courseTitle,
      courseThumbnail: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop',
      lectures: lectures,
      overallProgress: overallProgress,
      completedLectures: completedCount,
    );
  }

  void _onLectureTap(LectureProgressModel lecture) {
    if (lecture.isLocked) {
      _showLockedLectureMessage();
      return;
    }

    try {
      // Navigate to video player page
      context.pushNamed(
        AppRouteConstants.lecturedetailsPaage
        ).then((result) {
        // Refresh progress when returning from video player
        if (result == true) {
          _loadCourseProgress();
        }
      });
    } catch (e) {
      log('Error navigating to video player: $e');
      _showErrorMessage('Failed to open lecture');
    }
  }

  void _showLockedLectureMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete previous lectures to unlock this one'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
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
      body: isLoading ? _buildLoadingState() : _buildContent(),
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

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all( 20),
            child: Column(
              children: [
                ProgressOverviewCard(courseProgress: courseProgress),
                const SizedBox(height: 24),
                _buildLecturesSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
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
          widget.courseTitle,
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

  Widget _buildLecturesSection() {
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
        ...courseProgress.lectures.map((lecture) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LectureCard(
            lecture: lecture,
            onTap: () => _onLectureTap(lecture),
          ),
        )),
      ],
    );
  }
}
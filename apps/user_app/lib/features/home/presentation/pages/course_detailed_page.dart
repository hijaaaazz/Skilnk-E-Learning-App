import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/home/data/models/getcourse_details_params.dart';
import  'package:user_app/features/home/data/models/save_course_params.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/action_button.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/course_content.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/enrollment_handler.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/error-state.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/loading_skelton.dart';

class CourseDetailPage extends StatefulWidget {
  final String id;

  const CourseDetailPage({super.key, required this.id});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;
  bool _hasLoadedReviews = false; // Flag to prevent multiple review loads

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializePage() {
    try {
      final userId = context.read<AuthStatusCubit>().state.user?.userId ?? "";
      context.read<CourseCubit>().fetchCourseDetails(
            GetCourseDetailsParams(userId: userId, courseId: widget.id),
          );
      _hasLoadedReviews = false; // Reset flag when reinitializing
    } catch (e) {
      log('Error initializing page: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load course: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _loadReviewsAfterCourseLoaded(CourseEntity course) {
    if (!_hasLoadedReviews) {
      _hasLoadedReviews = true;
      // Load reviews immediately after course details are loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CourseCubit>().loadReviews(context, course);
      });
    }
  }

 

  void _handleBookmarkTap(CourseEntity course) {
    final userId = context.read<AuthStatusCubit>().state.user?.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save course'), backgroundColor: Colors.orange),
      );
      return;
    }
    context.read<CourseCubit>().toggleSaveCourse(
          context,
          SaveCourseParams(courseId: course.id, isSave: !course.isSaved, userId: userId),
        );
  }

  void _navigateToCoursePage(String id, String title) {
    context.pushNamed(
      AppRouteConstants.enrolledCoursedetailsPaage,
      extra: {
        'courseId': id,
        'courseTitle': title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseDetailsLoadingState) {
            return const LoadingSkeleton();
          } else if (state is CourseDetailsLoadedState) {
            // Load reviews immediately after course details are loaded
            _loadReviewsAfterCourseLoaded(state.coursedetails);
            
            return Stack(
              children: [
                CourseContent(
                  course: state.coursedetails,
                  scrollController: _scrollController,
                  selectedTabIndex: _selectedTabIndex,
                  isAppBarExpanded: _isAppBarExpanded,
                  onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                  onBookmarkTap: () => _handleBookmarkTap(state.coursedetails),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ActionButton(
                    course: state.coursedetails,
                    onTap: () => EnrollmentHandler.handleAction(
                      context,
                      state.coursedetails,
                      () => _navigateToCoursePage(
                        state.coursedetails.id,
                        state.coursedetails.title,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ReviewsLoadingState || 
                     state is ReviewsLoadedState || 
                     state is ReviewsErrorState ||
                     state is CourseFavoriteLoading ||
                     state is CourseFavoriteSuccess ||
                     state is CourseFavoriteFailure ||
                     state is CoursePurchaseProcessing ||
                     state is CoursePurchaseSuccess) {
            // Handle states that still have course details
            return Stack(
              children: [
                CourseContent(
                  course: state.course!,
                  scrollController: _scrollController,
                  selectedTabIndex: _selectedTabIndex,
                  isAppBarExpanded: _isAppBarExpanded,
                  onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                  onBookmarkTap: () => _handleBookmarkTap(state.course!),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ActionButton(
                    course: state.course!,
                    onTap: () => EnrollmentHandler.handleAction(
                      context,
                      state.course!,
                      () => _navigateToCoursePage(
                        state.course!.id,
                        state.course!.title,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CourseDetailsErrorState) {
            return ErrorState(errorMessage: state.errorMessage, onRetry: _initializePage);
          }
          return ErrorState(errorMessage: 'Course data unavailable', onRetry: _initializePage);
        },
      ),
    );
  }
}
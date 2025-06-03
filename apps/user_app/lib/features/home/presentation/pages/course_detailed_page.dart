// ignore: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/features/home/presentation/widgets/course-info.dart';
import 'package:user_app/features/home/presentation/widgets/about_tab.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
import 'package:user_app/features/home/presentation/widgets/instructor_card.dart';
import 'package:user_app/features/home/presentation/widgets/tab-selecter.dart';
import 'package:user_app/features/payment/presentation/bloc/bloc/enroll_bloc.dart';
import 'package:user_app/features/payment/presentation/bloc/bloc/enroll_state.dart';
import 'package:user_app/features/payment/presentation/widgets/payment_bottom_sheet.dart';

class CourseDetailPage extends StatefulWidget {
  final String id;

  const CourseDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
    _setupScrollListener();
  }

  void _initializePage() {
    try {
      // Fetch course details when page initializes
      final userId = context.read<AuthStatusCubit>().state.user?.userId;
      if (userId != null) {
        context.read<CourseCubit>().fetchCourseDetails(
          GetCourseDetailsParams(
            userId: userId,
            courseId: widget.id,
          )
        );
      } else {
        log('Warning: User ID is null when fetching course details');
        // Handle case where user is not logged in
        context.read<CourseCubit>().fetchCourseDetails(
          GetCourseDetailsParams(
            userId: "",
            courseId: widget.id,
          )
        );
      }
    } catch (e) {
      log('Error initializing page: $e');
    }
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      try {
        log(_scrollController.offset.toString());
        if (_scrollController.hasClients && mounted) {
          final expanded = _scrollController.offset <= MediaQuery.of(context).size.height * 0.3157;
          if (_isAppBarExpanded != expanded) {
            setState(() {
              _isAppBarExpanded = expanded;
            });
          }
        }
      } catch (e) {
        log('Error in scroll listener: $e');
      }
    });
  }

  void _showEnrollmentBottomSheet(CourseEntity course) {
    try {
      final userId = context.read<AuthStatusCubit>().state.user?.userId ?? "";
      final courseCubit = context.read<CourseCubit>();
      final parentContext = context;

      if (userId.isEmpty) {
        _showLoginRequiredMessage();
        return;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetContext) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => EnrollmentBloc(
                onPurchaseSuccess: (enrolledCourse) {
                  try {
                    courseCubit.onPurchase(parentContext, enrolledCourse);
                                    } catch (e) {
                    log('Error calling onPurchase: $e');
                    _showErrorMessage(parentContext, 'Failed to update course status');
                  }
                },
              ),
            ),
            BlocProvider<CourseCubit>.value(value: courseCubit),
          ],
          child: BlocListener<EnrollmentBloc, EnrollmentState>(
            listener: (context, state) {
              if (state is EnrollmentSuccess) {
                if (Navigator.of(bottomSheetContext).canPop()) {
                  Navigator.of(bottomSheetContext).pop();
                }
                _showSuccessMessage(parentContext, 'Successfully enrolled in course!');
              } else if (state is EnrollmentError) {
                _showErrorMessage(parentContext, state.message);
              }
            },
            child: EnrollmentBottomSheet(
              course: course,
              userId: userId,
              onEnrollmentSuccess: () {
                if (Navigator.of(bottomSheetContext).canPop()) {
                  Navigator.of(bottomSheetContext).pop();
                }
              },
            ),
          ),
        ),
      );
    } catch (e) {
      log('Error showing enrollment bottom sheet: $e');
      _showErrorMessage(context, 'Failed to open enrollment options');
    }
  }

  void _showLoginRequiredMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login to enroll in this course'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToCoursePage(CourseEntity course) {
    try {
      context.pushNamed(
        AppRouteConstants.enrolledCoursedetailsPaage
      );
    } catch (e) {
      log('Error navigating to course page: $e');
      _showErrorMessage(context, 'Failed to open course');
    }
  }

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.height.toString());
    
    return Scaffold(
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseDetailsLoadingState) {
            return _buildLoadingSkeleton();
          } else if (state is CourseDetailsLoadedState) {
            final course = state.coursedetails;
            if (course != null) {
              return _buildContent(course);
            } else {
              return _buildErrorState('Course data is not available');
            }
          } else if (state is CourseDetailsErrorState) {
            return _buildErrorState(state.errorMessage);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Error: $errorMessage',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _initializePage();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CourseEntity course) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(course),
            SliverToBoxAdapter(
              child: _buildCourseInfoCard(course),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabSelector(
                      tabs: const ['About', 'Curriculum'],
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _selectedTabIndex == 0
                          ? AboutTab(course: course)
                          : _buildCurriculumTab(course),
                    ),
                    
                    const SectionTitle(title: 'Instructor'),
                    const SizedBox(height: 16),
                    InstructorCard(
                      name: course.mentor.name,
                      imageUrl: course.mentor.imageUrl,
                    ),
                    const SizedBox(height: 24),
                    
                    if (course.totalReviews > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SectionTitle(title: 'Reviews'),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'SEE ALL',
                              style: TextStyle(
                                color: Color(0xFFFF6636),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildReviewsSection(course),
                    ],
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _handleActionButtonTap(course),
              child: _buildActionButton(course),
            ),
          ),
        ),
      ],
    );
  }

  void _handleActionButtonTap(CourseEntity course) {
    try {
      final user = context.read<AuthStatusCubit>().state.user;
      if (user == null) {
        _showLoginRequiredMessage();
        return;
      }
      
      if (course.isEnrolled) {
        _navigateToCoursePage(course);
      } else {
        _showEnrollmentBottomSheet(course);
      }
    } catch (e) {
      log('Error handling action button tap: $e');
      _showErrorMessage(context, 'An error occurred. Please try again.');
    }
  }

  Widget _buildSliverAppBar(CourseEntity course) {
    return SliverAppBar(
      surfaceTintColor: Colors.white,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      primary: true,
      backgroundColor: Colors.transparent,
      
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.deepOrange,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      
      actions: [
        BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseDetailsLoadedState) {
              // Use safe navigation to avoid null check errors
              final isSaved = state.course?.isSaved ?? course.isSaved;
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.deepOrange,
                ),
                onPressed: () => _handleBookmarkTap(course),
              );
            }
            if (state is CourseDetailsLoadingState) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.135,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        title: _isAppBarExpanded 
            ? null 
            : Text(
              course.title,
              style: const TextStyle(
                color: Color(0xFF202244),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: NetworkImage(course.courseThumbnail),
              fit: BoxFit.cover,
              opacity: 0.7,
            ),
          ),
        ),
      ),
    );
  }

  void _handleBookmarkTap(CourseEntity course) {
    try {
      final userId = context.read<AuthStatusCubit>().state.user?.userId;
      if (userId == null) {
        _showLoginRequiredMessage();
        return;
      }

      log("Course save status: ${course.isSaved}");
      context.read<CourseCubit>().toggleSaveCourse(
        context,
        SaveCourseParams(
          courseId: course.id,
          isSave: !course.isSaved,
          userId: userId,
        ),
      );
    } catch (e) {
      log('Error toggling bookmark: $e');
      _showErrorMessage(context, 'Failed to update bookmark');
    }
  }

  Widget _buildCourseInfoCard(CourseEntity course) {
    return CourseInfoCard(
      categoryName: course.categoryName,
      title: course.title,
      averageRating: course.averageRating,
      lessonsCount: course.lessons.length,
      duration: course.duration,
      price: course.price,
      offerPercentage: course.offerPercentage,
    );
  }

  Widget _buildCurriculumTab(CourseEntity course) {
    final lessons = course.lessons;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lessons.length,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8F1FF), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6636),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessons[index].title,
                      style: TextStyle(
                        color: course.isEnrolled 
                            ? const Color(0xFF202244) 
                            : const Color(0xFF888888),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(lessons[index].duration),
                      style: TextStyle(
                        color: course.isEnrolled 
                            ? const Color(0xFF545454) 
                            : const Color(0xFF999999),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                course.isEnrolled ? Icons.lock_open : Icons.lock,
                color: course.isEnrolled 
                    ? const Color(0xFF4CAF50) 
                    : const Color(0xFF888888),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _buildReviewsSection(CourseEntity course) {
    return Column(
      children: [
        const CourseReviewCard(
          name: 'Student Name',
          rating: 4.5,
          review: 'This course has been very useful. Mentor was well spoken and I totally loved it.',
          likes: 34,
          timeAgo: '2 Weeks Ago',
          imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
        ),
        const SizedBox(height: 16),
        if (course.totalReviews > 1)
          const CourseReviewCard(
            name: 'Another Student',
            rating: 4.0,
            review: 'Great content and well-structured lessons. I learned a lot from this course.',
            likes: 21,
            timeAgo: '3 Weeks Ago',
            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          ),
      ],
    );
  }

  Widget _buildActionButton(CourseEntity course) {
    if (course.isEnrolled) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color:Colors.deepOrange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Go to Course',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return _buildEnrollButton(course);
    }
  }

  Widget _buildEnrollButton(CourseEntity course) {
    String buttonText = 'Enroll Course';
    if (course.price > 0) {
      if (course.offerPercentage > 0) {
        final discountedPrice = calculateDiscountedPrice(course.price, course.offerPercentage);
        buttonText = 'Enroll Course - ₹$discountedPrice';
      } else {
        buttonText = 'Enroll Course - ₹${course.price}';
      }
    } else {
      buttonText = 'Enroll Course - Free';
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6636),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6636).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                color: Colors.grey[300],
              ),
              
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
        
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int calculateDiscountedPrice(int originalPrice, int discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) {
      return originalPrice;
    }
    
    final discount = (originalPrice * discountPercentage) ~/ 100;
    return originalPrice - discount;
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF202244),
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
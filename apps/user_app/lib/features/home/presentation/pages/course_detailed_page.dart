// ignore: file_names
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/features/home/presentation/widgets/course-info.dart';
import 'package:user_app/features/home/presentation/widgets/about_tab.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
import 'package:user_app/features/home/presentation/widgets/instructor_card.dart';
import 'package:user_app/features/home/presentation/widgets/tab-selecter.dart';

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
    // Fetch course details when page initializes
    context.read<CourseCubit>().fetchCourseDetails(widget.id);
    
    _scrollController.addListener(() {
      log(_scrollController.offset.toString());
      if (_scrollController.hasClients) {
        final expanded = _scrollController.offset <= MediaQuery.of(context).size.height * 0.3157;
        if (_isAppBarExpanded != expanded) {
          setState(() {
            _isAppBarExpanded = expanded;
          });
        }
      }
    });
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
            return _buildContent(course);
          } else if (state is CourseDetailsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CourseCubit>().fetchCourseDetails( widget.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildContent(CourseEntity course) {
    return Stack(
        children: [
          // Main content with SliverAppBar
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
                      // Tabs
                      TabSelector(
                        tabs: const ['About', 'Curriculum'],
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                      ),
                      
                      // Tab Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _selectedTabIndex == 0
                            ? AboutTab (course:  course)
                            : _buildCurriculumTab(course),
                      ),
                      
                     
                      
                      // Instructor Section
                      const SectionTitle(title: 'Instructor'),
                      const SizedBox(height: 16),
                       InstructorCard(
                        name: course.mentor.name,
                        imageUrl: course.mentor.imageUrl,
                      ),
                      const SizedBox(height: 24),
                      
                     
                      // Reviews Section
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
                      
                      // Extra space at the bottom for the fixed enroll button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Fixed Enroll Button at the bottom
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
              child: _buildEnrollButton(course),
            ),
          ),
        ],
      );
  }

  Widget _buildSliverAppBar(CourseEntity course) {
    return SliverAppBar(
      surfaceTintColor: Colors.white,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      primary: true,
      backgroundColor:  Colors.transparent ,
     
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.deepOrange,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      
      actions: [
        IconButton(
          icon: Icon(
            Icons.bookmark_border,
            color: Colors.deepOrange,
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        
        titlePadding: EdgeInsets.only(
          
         left:  MediaQuery.of(context).size.width* 0.135,
         bottom: MediaQuery.of(context).size.height*0.02
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
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (() {
                        final duration = lessons[index].duration;
                        final hours = duration.inHours;
                        final minutes = duration.inMinutes % 60;
                        if (hours > 0) {
                          return '${hours}h ${minutes}m';
                        } else {
                          return '${minutes}m';
                        }
                      })(),
                      style: const TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ),
              Icon(
                true ? Icons.lock : Icons.lock_open,
                color: const Color(0xFF202244),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
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
      child: Stack(
        children: [
          Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFFFF6636),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Stack(
      children: [
        // Skeleton for the main content
        SingleChildScrollView(
          child: Column(
            children: [
              // Skeleton for the AppBar space
              Container(
                height: 200,
                color: Colors.grey[300],
              ),
              
              // Skeleton for course info card
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
              
              // Skeleton for tabs
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
              
              // Skeleton for tab content
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
              
              // Skeleton for instructor
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
              
              // Space for bottom button
              const SizedBox(height: 100),
            ],
          ),
        ),
        
        // Skeleton for bottom button
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
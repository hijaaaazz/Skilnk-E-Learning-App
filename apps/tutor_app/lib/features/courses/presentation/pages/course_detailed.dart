import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/rating_bar.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    // Load course details when page is opened
    context.read<CoursesBloc>().add(LoadCourseDetail(courseId));


    return Scaffold(
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CourseDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(LoadCourseDetail(courseId));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is CourseDetailLoaded) {
            log(state.course.categoryName);
            final course = state.course;
            final discountedPrice = course.price - 
                (course.price * course.offerPercentage / 100).round();

            return CustomScrollView(
              slivers: [
                // App bar with course thumbnail as background
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          course.courseThumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 48),
                              ),
                            );
                          },
                        ),
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                // ignore: deprecated_member_use
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        context.pushNamed(
                          AppRouteConstants.addCourse,
                          extra: course, // pass the course to edit
                        );
                      },
                    ),

                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(context, course);
                        } else if (value == 'toggle') {
                          context.read<CoursesBloc>().add(
                                ToggleCourseStatus(
                                  courseId: course.id,
                                  isActive: !course.isActive,
                                ),
                              );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'toggle',
                          child: Text(
                            course.isActive ? 'Deactivate Course' : 'Activate Course',
                          ),
                        ),
                        // const PopupMenuItem<String>(
                        //   value: 'delete',
                        //   child: Text('Delete Course'),
                        // ),
                      ],
                    ),
                  ],
                ),

                // Course content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price and discount
                        Row(
                          children: [
                            if (course.offerPercentage > 0) ...[
                              Text(
                                '\$$discountedPrice',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${course.price}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${course.offerPercentage}% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Text(
                                '\$${course.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Course stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              Icons.people,
                              '${course.enrolledCount}',
                              'Students',
                            ),
                            _buildStatItem(
                              Icons.access_time,
                              '${course.duration} min',
                              'Duration',
                            ),
                            _buildStatItem(
                              Icons.signal_cellular_alt,
                              course.level,
                              'Level',
                            ),
                            _buildStatItem(
                              Icons.star,
                              course.averageRating.toStringAsFixed(1),
                              'Rating',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                         
                        const SizedBox(height: 8),
                        Text(
                          course.categoryName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                         ]),

                         const SizedBox(height: 24),

                        // Course description
                        const Text(
                          'About This Course',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                         

                        // Course lectures
                        const Text(
                          'Course Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${course.lessons.length} lectures • ${course.duration} minutes total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Lectures list
                        ...course.lessons.asMap().entries.map((entry) {
                          final index = entry.key;
                          final lecture = entry.value;
                          return _buildLectureItem(context, lecture, index + 1);
                        }),
                        
                        const SizedBox(height: 24),

                        // Ratings and reviews
                        const Text(
                          'Ratings & Reviews',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Rating summary
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  course.averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                RatingBar(rating: course.averageRating),
                                Text(
                                  '${course.totalReviews} reviews',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildRatingBar(5, course.ratingBreakdown['5'] ?? 0, course.totalReviews),
                                  _buildRatingBar(4, course.ratingBreakdown['4'] ?? 0, course.totalReviews),
                                  _buildRatingBar(3, course.ratingBreakdown['3'] ?? 0, course.totalReviews),
                                  _buildRatingBar(2, course.ratingBreakdown['2'] ?? 0, course.totalReviews),
                                  _buildRatingBar(1, course.ratingBreakdown['1'] ?? 0, course.totalReviews),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Reviews list (showing just a few)
                        if (course.reviews.isNotEmpty) ...[
                          ...course.reviews.take(3).map((review) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                review,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                          }),
                          
                          if (course.reviews.length > 3)
                            TextButton(
                              onPressed: () {
                                // Navigate to all reviews page
                              },
                              child: const Text('See all reviews'),
                            ),
                        ] else ...[
                          Text(
                            'No reviews yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Course not found'));
        },
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepOrange),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLectureItem(BuildContext context, LectureEntity lecture, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange,
          child: Text(
            '$index',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(lecture.title),
        subtitle: Text('${lecture.duration.inMinutes} min'),
        trailing: const Icon(Icons.play_circle_outline),
        onTap: () {
          context.pushNamed(AppRouteConstants.lectureDetails,extra: lecture);
        },
      ),
    );
  }

  Widget _buildRatingBar(int rating, int count, int total) {
    final percentage = total > 0 ? count / total : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$rating',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CourseEntity course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text(
          'Are you sure you want to delete "${course.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              //context.read<CoursesBloc>().add(DeleteCourse(course.id));
              context.pop(); // Go back to courses list
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

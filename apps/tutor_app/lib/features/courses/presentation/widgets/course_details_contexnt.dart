import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/presentation/widgets/build_stat_item.dart';
import 'package:tutor_app/features/courses/presentation/widgets/rating_bar.dart';

class CourseDetailContent extends StatelessWidget {
  final CourseEntity course;

  const CourseDetailContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        course.price - (course.price * course.offerPercentage / 100).round();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildStatItem(Icons.people, '${course.enrolledCount}', 'Students'),
                buildStatItem(Icons.access_time, '${course.duration} min', 'Duration'),
                buildStatItem(Icons.signal_cellular_alt, course.level, 'Level'),
                buildStatItem(Icons.star, course.averageRating.toStringAsFixed(1), 'Rating'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              course.categoryName,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'About This Course',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Course Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${course.lessons.length} lectures • ${course.duration} minutes total',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...course.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lecture = entry.value;
              return buildLectureItem(context, lecture, index + 1);
            }),
            const SizedBox(height: 24),
            const Text(
              'Ratings & Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      buildRatingBar(5, course.ratingBreakdown['5'] ?? 0, course.totalReviews),
                      buildRatingBar(4, course.ratingBreakdown['4'] ?? 0, course.totalReviews),
                      buildRatingBar(3, course.ratingBreakdown['3'] ?? 0, course.totalReviews),
                      buildRatingBar(2, course.ratingBreakdown['2'] ?? 0, course.totalReviews),
                      buildRatingBar(1, course.ratingBreakdown['1'] ?? 0, course.totalReviews),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                  onPressed: () {},
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
    );
  }
}
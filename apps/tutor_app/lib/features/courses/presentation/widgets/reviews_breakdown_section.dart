import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/courses/data/models/review_model.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/build_stat_item.dart';
import 'package:tutor_app/features/courses/presentation/widgets/rating_bar.dart';


class ReviewBreakDown extends StatelessWidget {
  const ReviewBreakDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CourseDetailLoaded ||
            state is ReviewsLoadingState ||
            state is ReviewsLoadedState ||
            state is ReviewsErrorState) {
          
          final course = (state as CourseDetailLoaded).course;
          final reviews = (state is ReviewsLoadedState) ? state.reviews : <ReviewModel>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        '${reviews.length.toString()} reviews',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                 Expanded(
  child: Column(
    children: List.generate(5, (index) {
      final star = 5 - index;
      final count = reviews.where((r) => r.rating == star).length;
      return buildRatingBar(star, count, reviews.length);
    }),
  ),
),

                ],
              ),
              const SizedBox(height: 16),

              if (state is ReviewsLoadingState) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (state is ReviewsErrorState) ...[
                Center(
                  child: Text(
                    'Failed to load reviews',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ] else if (reviews.isNotEmpty) ...[
                ...reviews.map((review) {
                  return Padding(
  padding: const EdgeInsets.only(bottom: 16.0),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(color: Colors.grey.shade100),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(review.reviewerImage),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                review.reviewerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              timeAgo(review.reviewedAt),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RatingBar(rating: review.rating.toDouble()),
        const SizedBox(height: 8),
        Text(
          review.review,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            height: 1.4,
          ),
        ),
      ],
    ),
  ),
);
                }),
                  
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
          );
        } else if (state is CourseDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox(); // fallback
        }
      },
    );
  }
  String timeAgo(DateTime date) {
  final duration = DateTime.now().difference(date);

  if (duration.inDays >= 1) return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago';
  if (duration.inHours >= 1) return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} ago';
  if (duration.inMinutes >= 1) return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''} ago';
  return 'Just now';
}

}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_section.dart';
import 'package:user_app/features/home/presentation/widgets/detailed_page/addr_review_bottom_sheet.dart';
import 'package:user_app/features/home/presentation/widgets/section_tile.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  String _timeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays >= 1) return '${duration.inDays} day(s) ago';
    if (duration.inHours >= 1) return '${duration.inHours} hour(s) ago';
    return '${duration.inMinutes} min(s) ago';
  }

 @override
Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      buildWhen: (previous, current) =>
          current is ReviewsLoadedState || current is ReviewsLoadingState,
      builder: (context, state) {
        final course = state.course;

        // Handle initial loading state (no reviews yet)
        if (state is ReviewsLoadingState && !state.isLoadingMore) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReviewsLoadedState || (state is ReviewsLoadingState && state.isLoadingMore)) {

          
          final reviews = state.reviews ?? [];
          final displayedReviewCount = (state is ReviewsLoadedState) ? state.displayedReviewCount : reviews.length;
          final hasMoreReviews = (state is ReviewsLoadedState) ? state.hasMoreReviews : true;
          final isLoadingMore = state is ReviewsLoadingState && state.isLoadingMore;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionTitle(title: 'Reviews'),
                  if (course?.isEnrolled == true)
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) {
                            return RepositoryProvider.value(
                              value: context.read<CourseCubit>(),
                              child: AddReviewBottomSheet(
                                courseId: course!.id,
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        'ADD REVIEW',
                        style: TextStyle(
                          color: Color(0xFFFF6636),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reviews.isEmpty)
                    const Center(child: Text("No reviews yet.")),

                  const SizedBox(height: 8),

                  ...reviews.take(displayedReviewCount).map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CourseReviewCard(
                        name: review.reviewerName,
                        rating: review.rating,
                        review: review.review,
                        likes: 0,
                        timeAgo: _timeAgo(review.reviewedAt),
                        imageUrl: review.reviewerImage,
                      ),
                    ),
                  ),

                  if (hasMoreReviews || displayedReviewCount < reviews.length)
                    Align(
                      alignment: Alignment.centerRight,
                      child: isLoadingMore
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () {
                                context.read<CourseCubit>().loadMoreReviews(context, course!);
                              },
                              child: const Text(
                                'Show more.',
                                style: TextStyle(
                                  color: Color(0xFFFF6636),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                    ),
                ],
              ),
            ),

              
            ],
          );
        }

        return const SizedBox.shrink(); // No reviews or error
      },
    );
}
}

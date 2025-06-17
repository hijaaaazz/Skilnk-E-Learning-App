import 'package:flutter/material.dart';
import 'package:user_app/features/home/presentation/widgets/course_review_card.dart';
import 'package:user_app/features/home/presentation/widgets/section_tile.dart';

class ReviewsSection extends StatelessWidget {
  final int totalReviews;

  const ReviewsSection({super.key, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(title: 'Reviews'),
            TextButton(
              onPressed: () {},
              child: const Text('SEE ALL', style: TextStyle(color: Color(0xFFFF6636), fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const CourseReviewCard(
          name: 'Student Name',
          rating: 4.5,
          review: 'This course has been very useful. Mentor was well spoken and I totally loved it.',
          likes: 34,
          timeAgo: '2 Weeks Ago',
          imageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36',
        ),
        if (totalReviews > 1) ...[
          const SizedBox(height: 16),
          const CourseReviewCard(
            name: 'Another Student',
            rating: 4.0,
            review: 'Great content and well-structured lessons. I learned a lot from this course.',
            likes: 21,
            timeAgo: '3 Weeks Ago',
            imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
          ),
        ],
      ],
    );
  }
}
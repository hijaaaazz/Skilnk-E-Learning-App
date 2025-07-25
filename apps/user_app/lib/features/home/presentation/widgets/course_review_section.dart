
import 'package:flutter/material.dart';

class CourseReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String review;
  final int likes;
  final String timeAgo;
  final String imageUrl;

  const CourseReviewCard({
    super.key,
    required this.name,
    required this.rating,
    required this.review,
    required this.likes,
    required this.timeAgo,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < rating.floor() ? Icons.star : Icons.star_border,
                            color: const Color(0xFFFF6B00),
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFF202244),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(
                  color: Color(0xFFA0A4AB),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: const TextStyle(
              color: Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          // const SizedBox(height: 12),
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.thumb_up_outlined,
          //       color: Color(0xFF202244),
          //       size: 16,
          //     ),
          //     const SizedBox(width: 4),
          //     Text(
          //       '$likes',
          //       style: const TextStyle(
          //         color: Color(0xFF202244),
          //         fontSize: 12,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

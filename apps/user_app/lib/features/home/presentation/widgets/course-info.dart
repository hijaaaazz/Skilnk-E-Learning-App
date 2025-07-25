// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CourseInfoCard extends StatelessWidget {
  final String categoryName;
  final String title;
  final double averageRating;
  final int lessonsCount;
  final Duration duration;
  final int price;
  final int offerPercentage;

  const CourseInfoCard({
    super.key,
    required this.categoryName,
    required this.title,
    required this.averageRating,
    required this.lessonsCount,
    required this.duration,
    required this.price,
    required this.offerPercentage,
  });

  int _calculateDiscountedPrice() {
    if (offerPercentage <= 0 || offerPercentage > 100) {
      return price;
    }
    
    final discount = (price * offerPercentage) ~/ 100;
    return price - discount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryName,
                  style: const TextStyle(
                    color: Color(0xFFFF6B00),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xFFFF6B00),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Course Title
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF202244),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Course Stats
            Row(
              children: [
                const Icon(
                  Icons.play_lesson,
                  size: 16,
                  color: Color(0xFF202244),
                ),
                const SizedBox(width: 8),
                Text(
                  '$lessonsCount Classes',
                  style: const TextStyle(
                    color: Color(0xFF202244),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '|',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF202244),
                ),
                const SizedBox(width: 8),
                Text(
  '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')} Hours',
  style: const TextStyle(
    color: Color(0xFF202244),
    fontSize: 11,
    fontWeight: FontWeight.w800,
  ),
),
                const Spacer(),
                // Show price
                if (price > 0)
                  Text(
                    offerPercentage > 0 
                        ? '₹${_calculateDiscountedPrice()}'
                        : '₹$price',
                    style: const TextStyle(
                      color: Color(0xFFFF6636),
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                else
                  const Text(
                    'Free',
                    style: TextStyle(
                      color: Color(0xFFFF6636),
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
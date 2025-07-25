import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromotionCardShimmer extends StatelessWidget {
  const PromotionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16/7,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Base shimmer color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Stack(
            children: [
              // Decorative circles for visual appeal (shimmer version)
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                right: 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              
              // Content skeletons
              // Badge skeleton
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              
              // Title skeleton
              Positioned(
                top: 45,
                left: 16,
                right: 60,
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              
              // Description skeleton (2 lines)
              Positioned(
                top: 75,
                left: 16,
                right: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/skeltons/skelton_loader.dart';

class StatCardSkeleton extends StatelessWidget {
  final bool isFullWidth;

  const StatCardSkeleton({Key? key, this.isFullWidth = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.circular(12),
              ),
              SkeletonLoader(
                width: 60,
                height: 24,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          SizedBox(height: 16),
          SkeletonLoader(
            width: 80,
            height: 32,
            borderRadius: BorderRadius.circular(8),
          ),
          SizedBox(height: 4),
          SkeletonLoader(
            width: 60,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class EarningsCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(width: 80, height: 20),
              SkeletonLoader(width: 100, height: 32, borderRadius: BorderRadius.circular(12)),
            ],
          ),
          SizedBox(height: 20),
          SkeletonLoader(width: 150, height: 36),
          SizedBox(height: 8),
          SkeletonLoader(width: 100, height: 16),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(6, (index) => 
              Column(
                children: [
                  SkeletonLoader(width: 20, height: 40 + (index * 10).toDouble()),
                  SizedBox(height: 8),
                  SkeletonLoader(width: 30, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivitySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(width: 120, height: 20),
                SkeletonLoader(width: 60, height: 16),
              ],
            ),
          ),
          ...List.generate(5, (index) => 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  SkeletonLoader(
                    width: 40,
                    height: 40,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(width: double.infinity, height: 16),
                        SizedBox(height: 4),
                        SkeletonLoader(width: 100, height: 12),
                      ],
                    ),
                  ),
                  SkeletonLoader(width: 50, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Top row - Students and Courses
          Row(
            children: [
              Expanded(child: StatCardSkeleton()),
              SizedBox(width: 12),
              Expanded(child: StatCardSkeleton()),
            ],
          ),
          SizedBox(height: 12),
          
          // Sales card
          StatCardSkeleton(isFullWidth: true),
          SizedBox(height: 20),
          
          // Earnings card
          EarningsCardSkeleton(),
        ],
      ),
    );
  }
}

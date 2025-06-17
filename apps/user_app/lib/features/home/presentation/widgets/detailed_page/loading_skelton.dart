import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 200, color: Colors.grey[300]),
              _buildShimmerBox(height: 180, margin: const EdgeInsets.all(16)),
              _buildShimmerBox(height: 40, margin: const EdgeInsets.symmetric(horizontal: 16)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(3, (_) => _buildShimmerBox(height: 100, margin: const EdgeInsets.only(bottom: 16))),
                ),
              ),
              _buildShimmerBox(height: 100, margin: const EdgeInsets.symmetric(horizontal: 16)),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildShimmerBox(height: 80, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
        ),
      ],
    );
  }

  Widget _buildShimmerBox({required double height, EdgeInsets? margin, EdgeInsets? padding}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
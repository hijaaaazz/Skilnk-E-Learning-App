import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';

class CourseCard extends StatelessWidget {
  final CoursePreview course;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
  final hasThumbnail = course.thumbnailUrl.isNotEmpty;

  return Stack(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 12,
          child: hasThumbnail
              ? Image.network(
                  course.thumbnailUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder_image.png', // your fallback image
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  'assets/images/placeholder_image.png',
                  fit: BoxFit.cover,
                ),
        ),
      ),
      
      if (course.offerPercentage > 0)
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5722),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5722).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${course.offerPercentage}% OFF',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ),
      
      if (!course.listed)
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Text(
                    'INACTIVE',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}


  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              _buildLevelChip(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5722).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        course.level,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFFFF5722),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  
}

class CourseCardSkeleton extends StatelessWidget {
  const CourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonContainer(
            height: 120,
            width: double.infinity,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonContainer(
                  height: 16,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                _SkeletonContainer(
                  height: 12,
                  width: 80,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: index < 4 ? 4 : 0),
                      child: _SkeletonContainer(
                        height: 12,
                        width: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonContainer extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const _SkeletonContainer({
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  State<_SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<_SkeletonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[200]!,
                Colors.grey[100]!,
                Colors.grey[200]!,
              ],
              stops: [
                0.0,
                _animation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

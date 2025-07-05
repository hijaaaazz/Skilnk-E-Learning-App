import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;

  const CourseCard({
    Key? key,
    required this.course,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallCard = constraints.maxWidth < 250;
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image
                Expanded(
                  flex: isSmallCard ? 3 : 2,
                  child: _buildCourseImage(isSmallCard),
                ),
                
                // Course Content
                Expanded(
                  flex: isSmallCard ? 4 : 3,
                  child: Padding(
                    padding: EdgeInsets.all(isSmallCard ? 8.0 : 12.0),
                    child: _buildCourseContent(context, isSmallCard),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseImage(bool isSmallCard) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              course.courseThumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    size: isSmallCard ? 30 : 50,
                    color: Colors.grey,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Badges
        Positioned(
          top: 6,
          left: 6,
          right: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Level Badge
              _buildBadge(
                course.level,
                Colors.blue,
                isSmallCard ? 8 : 10,
              ),
              
              // Discount Badge
              if (course.offerPercentage > 0)
                _buildBadge(
                  '${course.offerPercentage}% OFF',
                  Colors.red,
                  isSmallCard ? 8 : 10,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseContent(BuildContext context, bool isSmallCard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallCard ? 6 : 8,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            course.categoryName,
            style: TextStyle(
              fontSize: isSmallCard ? 8 : 10,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        SizedBox(height: isSmallCard ? 4 : 8),
        
        // Title
        Flexible(
          child: Text(
            course.title,
            style: TextStyle(
              fontSize: isSmallCard ? 12 : 14,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            maxLines: isSmallCard ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        if (!isSmallCard) ...[
          const SizedBox(height: 4),
          
          // Description
          Flexible(
            child: Text(
              course.description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        
        SizedBox(height: isSmallCard ? 4 : 8),
        
        // Course Stats
        if (!isSmallCard)
          _buildCourseStats(isSmallCard),
        
        SizedBox(height: isSmallCard ? 4 : 6),
        
        // Rating
        _buildRating(isSmallCard),
        
        if (!isSmallCard) ...[
          const SizedBox(height: 4),
          
          // Students Count
          _buildStudentsCount(isSmallCard),
        ],
        
        const Spacer(),
        
        // Price and Instructor
        _buildPriceSection(isSmallCard),
      ],
    );
  }

  Widget _buildBadge(String text, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCourseStats(bool isSmallCard) {
    return Wrap(
      spacing: 8,
      runSpacing: 2,
      children: [
        _buildStatItem(
          Icons.access_time,
          _formatDuration(course.duration),
          isSmallCard,
        ),
        _buildStatItem(
          Icons.play_lesson,
          '${course.lessons.length} lessons',
          isSmallCard,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text, bool isSmallCard) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isSmallCard ? 10 : 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallCard ? 9 : 10,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRating(bool isSmallCard) {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: isSmallCard ? 12 : 14,
          color: Colors.amber,
        ),
        const SizedBox(width: 2),
        Text(
          course.averageRating.toString(),
          style: TextStyle(
            fontSize: isSmallCard ? 10 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            '(${course.totalReviews})',
            style: TextStyle(
              fontSize: isSmallCard ? 9 : 10,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsCount(bool isSmallCard) {
    return Row(
      children: [
        Icon(
          Icons.people,
          size: isSmallCard ? 10 : 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            '${_formatNumber(course.enrolledCount)} students',
            style: TextStyle(
              fontSize: isSmallCard ? 9 : 10,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(bool isSmallCard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Price
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (course.offerPercentage > 0) ...[
                Row(
                  children: [
                    Text(
                      '\$${course.price.toInt()}',
                      style: TextStyle(
                        fontSize: isSmallCard ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '\$${course.price}',
                        style: TextStyle(
                          fontSize: isSmallCard ? 10 : 12,
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  '\$${course.price}',
                  style: TextStyle(
                    fontSize: isSmallCard ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Instructor
        if (!isSmallCard)
          Flexible(
            flex: 1,
            child: Text(
              'by ${course.tutor}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}

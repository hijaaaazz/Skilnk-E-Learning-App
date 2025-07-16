import 'package:admin_app/features/courses/presentation/bloc/bloc/courses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/common/widgets/dialog.dart';

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
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey[50]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: course.isBanned ? null : onTap, // Disable tap if banned
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isSmallCard ? 3 : 2,
                    child: _buildCourseImage(context, isSmallCard),
                  ),
                  Expanded(
                    flex: isSmallCard ? 4 : 3,
                    child: Padding(
                      padding: EdgeInsets.all(isSmallCard ? 10.0 : 14.0),
                      child: _buildCourseContent(context, isSmallCard),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseImage(BuildContext context, bool isSmallCard) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.network(
              course.courseThumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    size: isSmallCard ? 40 : 60,
                    color: Colors.grey[400],
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (course.isBanned)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Text(
                  'BANNED',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge(
                course.level,
                Colors.blue[600]!,
                isSmallCard ? 10 : 12,
              ),
              if (course.offerPercentage > 0 && !course.isBanned)
                _buildBadge(
                  '${course.offerPercentage}% OFF',
                  Colors.red[600]!,
                  isSmallCard ? 10 : 12,
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
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallCard ? 8 : 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.blue[100]!],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Text(
            course.categoryName,
            style: TextStyle(
              fontSize: isSmallCard ? 10 : 12,
              color: Colors.blue[800],
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: isSmallCard ? 6 : 10),
        Flexible(
          child: Text(
            course.title,
            style: TextStyle(
              fontSize: isSmallCard ? 14 : 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: course.isBanned ? Colors.grey[400] : Colors.black87,
            ),
            maxLines: isSmallCard ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!isSmallCard) ...[
          SizedBox(height: isSmallCard ? 4 : 8),
          Flexible(
            child: Text(
              course.description,
              style: TextStyle(
                fontSize: 12,
                color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        SizedBox(height: isSmallCard ? 6 : 10),
        if (!isSmallCard) _buildCourseStats(isSmallCard),
        SizedBox(height: isSmallCard ? 4 : 8),
        _buildRating(isSmallCard),
        if (!isSmallCard) ...[
          SizedBox(height: isSmallCard ? 4 : 6),
          _buildStudentsCount(isSmallCard),
        ],
        const Spacer(),
        _buildPriceSection(context, isSmallCard),
      ],
    );
  }

  Widget _buildBadge(String text, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCourseStats(bool isSmallCard) {
    return Wrap(
      spacing: 10,
      runSpacing: 4,
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
          size: isSmallCard ? 12 : 14,
          color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmallCard ? 10 : 12,
              color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
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
          size: isSmallCard ? 14 : 16,
          color: course.isBanned ? Colors.grey[400] : Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          course.averageRating.toString(),
          style: TextStyle(
            fontSize: isSmallCard ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: course.isBanned ? Colors.grey[400] : Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '(${course.totalReviews})',
            style: TextStyle(
              fontSize: isSmallCard ? 10 : 12,
              color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
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
          size: isSmallCard ? 12 : 14,
          color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '${_formatNumber(course.enrolledCount)} students',
            style: TextStyle(
              fontSize: isSmallCard ? 10 : 12,
              color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, bool isSmallCard) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (course.offerPercentage > 0 && !course.isBanned) ...[
                Row(
                  children: [
                    Text(
                      '\$${course.price.toInt()}',
                      style: TextStyle(
                        fontSize: isSmallCard ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: course.isBanned ? Colors.grey[400] : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '\$${course.price}',
                        style: TextStyle(
                          fontSize: isSmallCard ? 12 : 14,
                          color: course.isBanned ? Colors.grey[400] : Colors.grey[600],
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
                    fontSize: isSmallCard ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: course.isBanned ? Colors.grey[400] : Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
         _buildBanButton(context, isSmallCard),
      ],
    );
  }

  Widget _buildBanButton(BuildContext context, bool isSmallCard) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showBanDialog(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallCard ? 10 : 12,
            vertical: isSmallCard ? 6 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: course.isBanned
                  ? [Colors.green[400]!, Colors.green[600]!]
                  : [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                course.isBanned ? Icons.check_circle : Icons.block,
                size: isSmallCard ? 14 : 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                course.isBanned ? 'Unban' : 'Ban',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallCard ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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

  void _showBanDialog(BuildContext context) {
    CustomDialog.show(
      context: context,
      title: course.isBanned ? "Unban Course" : "Ban Course",
      content: Text(
        course.isBanned
            ? "Are you sure you want to unban '${course.title}'? It will be accessible again."
            : "Are you sure you want to ban '${course.title}'? It will be inaccessible to users.",
      ),
      onDone: () {
        context.read<CoursesBloc>().add(
              BanCourse(courseId: course.id),
            );
      },
    );
  }
}
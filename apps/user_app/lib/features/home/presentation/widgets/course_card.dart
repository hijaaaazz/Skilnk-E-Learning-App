import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

class CourseCard extends StatelessWidget {
  final CoursePreview course;
  
  final bool isPartiallyVisible;

  const CourseCard({
    super.key,
    required this.course,
    
    this.isPartiallyVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.pushNamed(AppRouteConstants.coursedetailsPaage,extra: course.id);
      },
      borderRadius: BorderRadius.circular(16) ,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: course.thumbnail.isNotEmpty
                  ? Image.network(
                      course.thumbnail,
                      height: 120,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        width: 200,
                        color: Colors.grey,
                      ),
                    )
                  : Container(
                      height: 120,
                      width: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.categoryname,
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.courseTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        num.parse(course.price) == 0 ?
                        "Free":
                        course.price.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.averageRating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                     
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

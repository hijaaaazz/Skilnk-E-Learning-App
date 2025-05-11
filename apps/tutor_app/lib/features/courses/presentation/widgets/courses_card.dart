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
    // final discountedPrice = course.price - 
    //     (course.price * course.offerPercentage / 100).round();
    
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course thumbnail
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    course.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 32),
                        ),
                      );
                    },
                  ),
                ),
               // if (course.offerPercentage > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${course.title}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
               if (!course.isActive)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: const Center(
                        child: Text(
                          'INACTIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course title
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Course level
                  Row(
                    children: [
                      Icon(
                        Icons.signal_cellular_alt,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.level,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Course rating
                 Row(
  children: [
    ...List.generate(5, (index) {
      double currentStar = index + 1;
      return Icon(
        currentStar <= course.rating
            ? Icons.star
            : (course.rating >= currentStar - 0.5 ? Icons.star_half : Icons.star_border),
        size: 14,
        color: Colors.amber[700],
      );
    }),
    const SizedBox(width: 4),
    Text(
      course.rating.toStringAsFixed(1), // e.g. "4.2"
      style: TextStyle(
        fontSize: 12,
        color: Colors.amber[700],
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),

                  const SizedBox(height: 8),
                  
                  // Course price
                  Row(
                    children: [
                      //if (course.offerPercentage > 0) ...[
                        Text(""
                          //'\$${discountedPrice}',
                          ,style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${course.title}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      //]
                       //else ...[
                        Text(
                          '\$${course.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepOrange,
                          ),
                        ),
                      //],
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

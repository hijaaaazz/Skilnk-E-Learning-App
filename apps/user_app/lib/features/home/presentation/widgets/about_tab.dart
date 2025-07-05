import 'package:flutter/material.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/presentation/widgets/course_fueture_.item.dart';
import  'package:user_app/features/home/presentation/widgets/section_tile.dart';

class AboutTab extends StatefulWidget {
  final CourseEntity course;
  
  const AboutTab({super.key, required this.course});
  
  @override
  // ignore: library_private_types_in_public_api
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  bool isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return _buildAboutTab(widget.course);
  }
  
  Widget _buildAboutTab(CourseEntity course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // This is the collapsed version that shows when isExpanded is false
        if (!isExpanded) ...[
          Text(
            course.description,
            style: const TextStyle(
              color: Color(0xFFA0A4AB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.46,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: const Text(
              'Read More',
              style: TextStyle(
                color: Color(0xFFFF6636),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                height: 1.46,
              ),
            ),
          ),
        ],
        // This is the expanded version that shows when isExpanded is true
        if (isExpanded) ...[
          Text(
            course.description,
            style: const TextStyle(
              color: Color(0xFFA0A4AB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.46,
            ),
          ),
          const SizedBox(height: 8),
          
          const SizedBox(height: 16),
        
        // What You'll Get Section
        const SectionTitle(title: 'What You\'ll Get'),
        const SizedBox(height: 16),
        _buildFeaturesList(course),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = false;
              });
            },
            child: const Text(
              'Show Less',
              style: TextStyle(
                color: Color.fromARGB(255, 156, 156, 156),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.46,
              ),
            ),
          ),
        ],
        
        
      ],
    );
  }

  Widget _buildFeaturesList(CourseEntity course) {
    final features = [
      {'icon': Icons.book, 'text': '${course.lessons.length} Lessons'},
      {'icon': Icons.signal_cellular_alt, 'text': '${course.level} Level'},
      {'icon': Icons.language, 'text': course.language},
    ];

    return Column(
      children: features
          .map((feature) => CourseFeatureItem(
                icon: feature['icon'] as IconData,
                text: feature['text'] as String,
              ))
          .toList(),
    );
  }

  
 
}
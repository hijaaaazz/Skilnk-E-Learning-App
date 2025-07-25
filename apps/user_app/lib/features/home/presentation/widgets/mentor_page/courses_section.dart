import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/course_list/data/models/list_page_arg.dart';
import  'package:user_app/features/explore/presentation/widgets/course_tile.dart';
import  'package:user_app/features/home/domain/entity/course_privew.dart';

class CoursesSection extends StatelessWidget {
  final List<CoursePreview> courses;
  final List<String> sessionIds;
  final String mentorName;
  final int totalCourse;

  const CoursesSection({
    super.key,
    required this.courses,
    required this.sessionIds,
    required this.totalCourse,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRouteConstants.courselistPaage,
                extra: CourseListPageArgs(
                  courseIds: sessionIds,
                  title: "$mentorName's Courses",
                ),
              );
            },
            child: Row(
              children: [
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$totalCourse',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: const Color(0xFFFF6B35),
                ),
              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseTile(course: course);
          },
        ),
      ],
    );
  }
}
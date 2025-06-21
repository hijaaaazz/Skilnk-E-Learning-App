import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
import 'package:user_app/features/explore/presentation/widgets/course_tile.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

class CoursesSection extends StatelessWidget {
  final List<CoursePreview> courses;
  final List<String> sessionIds;
  final String mentorName;

  const CoursesSection({
    super.key,
    required this.courses,
    required this.sessionIds,
    required this.mentorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202244),
                  ),
                ),
                const Spacer(),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
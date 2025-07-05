import 'package:flutter/material.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/presentation/widgets/about_tab.dart';
import  'package:user_app/features/home/presentation/widgets/detailed_page/curicculum_tab.dart';

class TabContent extends StatelessWidget {
  final CourseEntity course;
  final int selectedTabIndex;

  const TabContent({
    super.key,
    required this.course,
    required this.selectedTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: selectedTabIndex == 0 ? AboutTab(course: course) : CurriculumTab(course: course),
    );
  }
}
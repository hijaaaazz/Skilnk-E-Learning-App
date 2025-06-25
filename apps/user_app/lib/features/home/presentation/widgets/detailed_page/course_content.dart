import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/presentation/widgets/course-info.dart';
import 'package:user_app/features/home/presentation/widgets/detailed_page/app_bar.dart';
import 'package:user_app/features/home/presentation/widgets/detailed_page/instuctor_section.dart';
import 'package:user_app/features/home/presentation/widgets/detailed_page/review_section.dart';
import 'package:user_app/features/home/presentation/widgets/detailed_page/tab_content.dart';
import 'package:user_app/features/home/presentation/widgets/tab-selecter.dart';

class CourseContent extends StatelessWidget {
  final CourseEntity course;
  final ScrollController scrollController;
  final int selectedTabIndex;
  final bool isAppBarExpanded;
  final Function(int) onTabSelected;
  final VoidCallback onBookmarkTap;

  const CourseContent({
    super.key,
    required this.course,
    required this.scrollController,
    required this.selectedTabIndex,
    required this.isAppBarExpanded,
    required this.onTabSelected,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        CourseAppBar(
          course: course,
          isAppBarExpanded: isAppBarExpanded,
          onBookmarkTap: onBookmarkTap,
        ),
        SliverToBoxAdapter(
          child: CourseInfoCard(
            categoryName: course.categoryName,
            title: course.title,
            averageRating: course.averageRating,
            lessonsCount: course.lessons.length,
            duration: course.duration,
            price: course.price,
            offerPercentage: course.offerPercentage,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabSelector(
                  tabs: const ['About', 'Curriculum'],
                  selectedIndex: selectedTabIndex,
                  onTabSelected: onTabSelected,
                ),
                TabContent(course: course, selectedTabIndex: selectedTabIndex),
                InstructorSection(mentor: course.mentor),
                ReviewsSection(), // Always include ReviewsSection
                const SizedBox(
                  height: 150,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
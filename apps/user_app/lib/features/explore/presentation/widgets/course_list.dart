// lib/features/explore/presentation/widgets/courses_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/explore/presentation/theme.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

class CoursesListWidget extends StatelessWidget {
  final List<CoursePreview> courses;
  
  const CoursesListWidget({
    Key? key,
    required this.courses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        // Show category indicator if a category is selected
        Widget categoryIndicator = const SizedBox.shrink();
        if (state.selectedCategoryId != null) {
          // Safely find the selected category
          final selectedCategoryEntity = state.allCategories.firstWhere(
            (c) => c.id == state.selectedCategoryId,
            orElse: () => CategoryEntity(id: '', description: "", title: '', courses: []),
          );
          if (selectedCategoryEntity.id.isNotEmpty) {
            categoryIndicator = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Category: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ExploreTheme.textColor,
                      fontSize: 14,
                    ),
                  ),
                  Chip(
                    label: Text(
                      selectedCategoryEntity.title,
                      style: TextStyle(
                        color: ExploreTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    deleteIcon: Icon(Icons.close, size: 16, color: ExploreTheme.primaryColor),
                    onDeleted: () {
                      context.read<ExploreBloc>().add(ClearCategory());
                    },
                    backgroundColor: ExploreTheme.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                ],
              ),
            );
          }
        }

        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              categoryIndicator,
              Expanded(
                child: courses.isEmpty
                    ? Center(
                        child: Text(
                          'No courses found${state.selectedCategoryId != null ? ' in this category' : ''}',
                          style: TextStyle(color: ExploreTheme.secondaryTextColor),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: Colors.grey.shade100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: ExploreTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: ExploreTheme.primaryColor,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.courseTitle,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: ExploreTheme.textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.amber, size: 16),
                                            Text(
                                              ' ${course.averageRating}',
                                              style: TextStyle(
                                                color: ExploreTheme.secondaryTextColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              ' • ',
                                              style: TextStyle(
                                                color: ExploreTheme.secondaryTextColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              course.categoryname,
                                              style: TextStyle(
                                                color: ExploreTheme.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    course.price,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: ExploreTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
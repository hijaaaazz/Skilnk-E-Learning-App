// lib/features/explore/presentation/widgets/courses_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/explore/presentation/theme.dart';
import 'package:user_app/features/explore/presentation/widgets/course_tile.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

class CoursesListWidget extends StatelessWidget {
  final List<CoursePreview> courses;
  
  const CoursesListWidget({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
      

        return Expanded(
          child:
          
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category indicator chip
              state.selectedCategory != null ?
              Visibility(
                visible:  state.selectedCategory != null,
                child: Padding(
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
                          state.selectedCategory!.title,
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
                        // ignore: deprecated_member_use
                        // ignore: deprecated_member_use
                        backgroundColor: ExploreTheme.primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ],
                  ),
                ),
              ): SizedBox.shrink(),
              // Course list or empty state
              if (state.isLoading)
                _buildCourseListSkeleton()
              else
                Expanded(
                  child: courses.isEmpty
                      ? Center(
                          child: Text(
                            'No courses found${state.selectedCategory?.title != null ? ' in this category' : ''}',
                            style: TextStyle(color: ExploreTheme.secondaryTextColor),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return CourseTile(course: course);
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


Widget _buildCourseListSkeleton() {
  return Expanded(
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(16)
                    )
                  ),
                  width: 100,
                  height: 100,
                  
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:12,horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 12,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 12,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 30,
                              height: 12,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

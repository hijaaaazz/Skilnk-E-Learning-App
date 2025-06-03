// lib/features/explore/presentation/widgets/courses_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
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
                          // Update course items to use a card style similar to CourseCard
return InkWell(
  onTap: () {
    context.pushNamed(AppRouteConstants.coursedetailsPaage, extra: course.id);
  },
  child: Container(
    width: MediaQuery.of(context).size.width * 0.9,
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Image.network(
            course.thumbnail,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        Expanded(
          child: Padding(
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
                      int.tryParse(course.price) == 0 ? 'Free' : '₹${course.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
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
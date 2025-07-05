import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import  'package:user_app/features/home/presentation/widgets/video_player/completetion_status.dart';

class CourseAppBar extends StatelessWidget {
  final CourseEntity course;
  final bool isAppBarExpanded;
  final VoidCallback onBookmarkTap;

  const CourseAppBar({
    super.key,
    required this.course,
    required this.isAppBarExpanded,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: Colors.white,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      primary: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.deepOrange),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseDetailsLoadedState) {
              final isSaved = state.coursedetails.isSaved;
              return IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.deepOrange),
                onPressed: onBookmarkTap,
              );
            }
            if (state is CourseDetailsLoadingState) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.135,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        title: isAppBarExpanded
            ? null
            : Text(
                course.title,
                style: const TextStyle(color: Color(0xFF202244), fontSize: 20, fontWeight: FontWeight.w600),
              ),
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(course.courseThumbnail),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
            ),
            IsCompletedBadge(isCompleted: course.isCompleted)
          ],
        ),
      ),
    );
  }
}
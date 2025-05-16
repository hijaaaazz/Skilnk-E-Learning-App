// curriculum.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:tutor_app/common/widgets/app_text.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/reordarable_list.dart';
import 'package:tutor_app/features/courses/presentation/widgets/step_page.dart';

class StepCurriculum extends StatelessWidget {
  const StepCurriculum({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CourseStepPage(
      title: "Curriculum",
      icon: Icons.play_circle_sharp,
      bodyContent: CurriculumBody(),
      onNext: () {
        // Validate curriculum before proceeding
        if (context.read<AddCourseCubit>().validateCurriculum(context)) {
          context.pushNamed(AppRouteConstants.addCoursePublishRouteName,extra: context.read<AddCourseCubit>());
        }
      },
    );
  }
}

class CurriculumBody extends StatelessWidget {
  const CurriculumBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCourseCubit, AddCourseState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Lectures : ${state.lessons.length}',
                  ),
                  IconButton(onPressed: (){
                     final cubit = context.read<AddCourseCubit>();
                    context.pushNamed(AppRouteConstants.addCourseaddlectureName,extra: cubit);
                  }, icon: Icon(Icons.add_circle_rounded)),
                ],
              ),
              
              // Lectures list
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                child: state.lessons.isEmpty 
                  ? _EmptyLecturesList() 
                  : ReorderableContentList(
                      items: state.lessons,
                      onReorder:(oldindex,newIndex){
                        context.read<AddCourseCubit>().reorderLectures(oldindex, newIndex);
                      } ,
                      onDelete:(index){
                        
                        context.read<AddCourseCubit>().removeLecture(index);
                      } ,
                      onEdit:(index){
                        final cubit = context.read<AddCourseCubit>();
                        cubit.startEditingLecture(index); // index - 1 because UI index starts at 1
                        context.pushNamed(
                          AppRouteConstants.addCourseaddlectureName,
                          extra: cubit,
                        );
                      } ,
                    ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyLecturesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No lectures added yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Click "Add Lecture" to start building your course',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

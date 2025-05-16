import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/app_text.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/step_page.dart';
import 'package:tutor_app/features/courses/presentation/widgets/text_field.dart';

class StepAdvancedInfo extends StatelessWidget {

  const StepAdvancedInfo({
    
    super.key,
   
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CourseStepPage(
            title: "Advanced",
            icon: Icons.image,
            backtext: "Previous",
            nexttext: "Continue",
            bodyContent:  AdvancedInfoBody(),
             onNext: (){
              final addCourseCubit = context.read<AddCourseCubit>();
                
                if (addCourseCubit.validateAdvancedInfo(context)) {
                 
                  final cubit = context.read<AddCourseCubit>();
                  context.pushNamed(
                    AppRouteConstants.addCourseCurriculumRouteName,
                    extra:cubit
                  );
                }
             },);
      }
    );
  }
}

class AdvancedInfoBody extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  AdvancedInfoBody({super.key});

  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCourseCubit,AddCourseState>(
      
      builder: (context, state) {
        if (_descriptionController.text != state.description) {
          _descriptionController.text = state.description;
        }
        return SingleChildScrollView(
          child: Column(
          children: [
            
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  AppText(text: "Course Thumbnail",),
                  InkWell(
                    highlightColor: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                    hoverDuration: Duration(seconds: 1),
                    onTap: (){
                      context.read<AddCourseCubit>().pickThumbnail();
                    },
                    child: Stack(
   children: [
  
  Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.18,
    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      // ignore: deprecated_member_use
      color: Colors.deepOrange.withOpacity(0.5),
      borderRadius: BorderRadius.circular(20),
      image: state.thumbnailPath.isNotEmpty
          ? DecorationImage(
              image: state.isEditing != null && state.isEditing == true
                  ? (state.thumbnailPath.startsWith('http') // Check if it's a URL
                      ? NetworkImage(state.thumbnailPath) 
                      : FileImage(File(state.thumbnailPath))) as ImageProvider
                  : FileImage(File(state.thumbnailPath)),
              fit: BoxFit.cover,
            )
          : null,
    ),
    child: Visibility(
      visible: state.thumbnailPath.isEmpty,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, color: Colors.white),
            AppText(
              text: state.thumbnailPath,
              color: Colors.white,
              weight: FontWeight.w500,
              size: 15,
            ),
          ],
        ),
      ),
    ),
  ),


  if (state.thumbnailPath.isNotEmpty)
    Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: const Color.fromARGB(83, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
],

)

                  ),
                
                  AppTextField(
                    label: "Course Description",
                    hintText: "Description",
                    
                    maxLength: 300,
                    errorText: state.descriptionError,
                    onChanged: (value) {
                      context.read<AddCourseCubit>().updateDescription(value);
                    },
                    controller: _descriptionController,
                    showCounter: true,
                    maxLines: 8,
                    )
                ],
              ),
            ),
            
          ],
                ),
        );
      },
    );
  }
}
  
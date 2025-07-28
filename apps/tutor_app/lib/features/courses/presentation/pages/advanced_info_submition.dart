import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
                      highlightColor: Colors.deepOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      hoverDuration: const Duration(milliseconds: 200),
                      onTap: () {
                        context.read<AddCourseCubit>().pickThumbnail();
                      },
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.18,
                              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                image: state.thumbnailPath.isNotEmpty
                                    ? DecorationImage(
                                        image: _getThumbnailImage(state),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          log('Error loading thumbnail: $exception');
                                        },
                                      )
                                    : null,
                              ),
                              child: Visibility(
                                visible: state.thumbnailPath.isEmpty,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: Colors.white,
                                      ),
                                      AppText(
                                        text: "Upload Thumbnail",
                                        color: Colors.white,
                                        weight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (state.thumbnailPath.isNotEmpty)
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(83, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
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
  

  ImageProvider _getThumbnailImage(AddCourseState state) {
    if (kIsWeb) {
      if (state.thumbnailPath.startsWith('data:image')) {
        final base64String = state.thumbnailPath.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } else if (state.thumbnailPath.startsWith('http')) {
        return NetworkImage(state.thumbnailPath);
      }
    } else {
      if (state.isEditing == true && state.thumbnailPath.startsWith('http')) {
        return NetworkImage(state.thumbnailPath);
      } else {
        return FileImage(File(state.thumbnailPath));
      }
    }
    return const AssetImage('assets/images/placeholder.png');
  }
}
  
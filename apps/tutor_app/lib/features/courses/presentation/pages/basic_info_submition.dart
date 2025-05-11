import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/language_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/auto_complete.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_price_form.dart';
import 'package:tutor_app/features/courses/presentation/widgets/custome_dropdown.dart';
import 'package:tutor_app/features/courses/presentation/widgets/step_page.dart';
import 'package:tutor_app/features/courses/presentation/widgets/text_field.dart';

class StepBasicInfo extends StatelessWidget {
  const StepBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
   
    
    return Builder(
      builder: (context) {
        return CourseStepPage(
          title: "Basic Info",
          icon: Icons.layers,
          bodyContent: SingleChildScrollView(
            child: CourseBasicInfoForm(),
          ),
          backtext: "Cancel",
          nexttext: "Continue",
          onNext: () {
            final addCourseCubit = context.read<AddCourseCubit>();
            
            // Clear validation state before validating to ensure we get fresh results
            addCourseCubit.clearValidationErrors();
            
            if (addCourseCubit.validateBasicInfo()) {
              addCourseCubit.getCourseCreationReq();
              
              // Navigate to next screen with course creation request
              context.pushNamed(
                AppRouteConstants.addCourseAdvancedRouteName,
                extra: addCourseCubit
              );
            }
          },
        );
      }
    );
  }
}

// ignore: must_be_immutable
class CourseBasicInfoForm extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(text: "0");
  final int _maxTitleLength = 80;
  
  CourseBasicInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCourseCubit, AddCourseState>(
      builder: (context, state) {
        // Sync controllers with cubit state without causing loops
        if (_titleController.text != state.title) {
          _titleController.text = state.title;
        }
        
        if (_priceController.text != state.price) {
          _priceController.text = state.price.toString();
        }

        
        return Stack(
          children: [
            state.isOptionsLoading ?? false
                ? Container()
                : Form(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTextField(
                                label: 'Title',
                                hintText: 'Your course title',
                                controller: _titleController,
                                maxLength: _maxTitleLength,
                                showCounter: true,
                                errorText: state.titleError ?? "",
                                onChanged: (value) {
                                  // Clear the error as soon as user starts typing
                                  context.read<AddCourseCubit>().updateTitle(value);
                                },
                              ),
                              
                              AppAutocomplete<CategoryEntity>(
                                label: 'Course Category',
                                hintText: 'Search for a category...',
                                initialValue: state.category?.title,
                                options: state.options?.categories ?? [],
                                displayStringForOption: (option) => option.title,
                                errorText: state.categoryError,
                                                        
                                onSelected: (category) {
                                  context.read<AddCourseCubit>().updateCategory(category);
                                },
                              ),
                              SizedBox(height: 15),
                          
                              // Course Language - Autocomplete
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.36,
                                    child: AppAutocomplete<LanguageEntity>(
                                      label: 'Course Language',
                                      hintText: 'Search for a language...',
                                      options: state.options?.languages ?? [],
                                      displayStringForOption: (option) => option.name,
                                      errorText: state.languageError,
                                      initialValue: state.language,
                                      optionBuilder: (context, option) {
                                        return ListTile(
                                          leading: option.flag.isNotEmpty
                                            ? Image.network(
                                                option.flag,
                                                width: 24,
                                                height: 16,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Icons.broken_image),
                                              )
                                            : const Icon(Icons.flag),
                                                            
                                          title: Text(option.name),
                                        );
                                      },
                                      onSelected: (language) {
                                        context.read<AddCourseCubit>().updateLanguage(language.name);
                                      },
                                    ),
                                  ),
                                                            
                                  // Course Level - Dropdown with validation
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.36,
                                    child: AppDropdown<String>(
                                      label: 'Course Level',
                                      hint: 'Select...',
                                      value: state.level,
                                      errorText: state.levelError,
                                      items: state.options?.levels.map((level) {
                                        return DropdownMenuItem<String>(
                                          value: level,
                                          child: Text(level),
                                        );
                                      }).toList() ?? [],
                                      onChanged: (value) {
                                        context.read<AddCourseCubit>().updateLevel(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Course Pricing Section
                              CoursePriceForm(
                                priceController: _priceController,
                                discountController: _discountController,
                                
                              )
                              
                              // Price TextField - Only visible if isPaid is true
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

              Visibility(
                visible: state.isOptionsLoading ?? false,
                child: const Center(child: BlurredLoading()),
              )
            ],
          );
        },
      );
  }
}
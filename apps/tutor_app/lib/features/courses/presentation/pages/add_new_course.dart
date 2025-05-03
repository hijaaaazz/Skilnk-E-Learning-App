import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/presentation/pages/widgets/advanced_info.dart';
import 'package:tutor_app/features/courses/presentation/pages/widgets/basic_info.dart';
import 'package:tutor_app/features/courses/presentation/pages/widgets/curicullum.dart';
import 'package:tutor_app/features/courses/presentation/pages/widgets/publish.dart';

class AddNewCoursePage extends StatefulWidget {
  const AddNewCoursePage({super.key});

  @override
  State<AddNewCoursePage> createState() => _AddNewCoursePageState();
}

class _AddNewCoursePageState extends State<AddNewCoursePage> {
  int _currentStep = 0;

  final formKey = GlobalKey<FormState>();

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  String selectedCategory = 'Programming';
  String selectedLevel = 'Beginner';
  String thumbnail = '';
  List<String> lessons = [];

  void _nextStep() {
    if (formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [
      StepBasicInfo(
        titleController: titleController,
        descriptionController: descriptionController,
        selectedCategory: selectedCategory,
        onCategoryChanged: (val) => setState(() => selectedCategory = val),
        onThumbnailChanged: (val) => setState(() => thumbnail = val),
      ),
      StepAdvancedInfo(
        priceController: priceController,
        discountController: discountController,
        selectedLevel: selectedLevel,
        onLevelChanged: (val) => setState(() => selectedLevel = val),
      ),
      StepCurriculum(
        lessons: lessons,
        onAddLesson: (lesson) => setState(() => lessons.add(lesson)),
      ),
      const StepPublish(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Course')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(child: steps[_currentStep]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: _currentStep == steps.length - 1
                        ? () {
                            // Final submit logic
                          }
                        : _nextStep,
                    child: Text(_currentStep == steps.length - 1 ? 'Submit' : 'Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

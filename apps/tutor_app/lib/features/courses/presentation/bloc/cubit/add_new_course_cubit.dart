// import 'dart:developer';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:tutor_app/common/usecase/usecase.dart';
// import 'package:tutor_app/features/courses/data/models/course_params.dart';
// import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
// import 'package:tutor_app/features/courses/domain/usecases/upload_thumbnail.dart';
// import 'package:tutor_app/service_locator.dart';

// enum AddCourseStatus {
//   initial,
//   uploadingThumbnail,
//   thumbnailUploaded,
//   submitting,
//   submitted,
//   failure,
// }

// class AddCourseState {
//   final AddCourseStatus status;
//   final int currentStep;
//   final String selectedCategory;
//   final String selectedLevel;
//   final List<String> lessons;
//   final String courseThumbnail;
//   final String? errorMessage;

//   AddCourseState({
//     required this.status,
//     this.currentStep = 0,
//     this.selectedCategory = '',
//     this.selectedLevel = '',
//     this.lessons = const [],
//     this.courseThumbnail = '',
//     this.errorMessage,
//   });

//   factory AddCourseState.initial() => AddCourseState(status: AddCourseStatus.initial);

//   AddCourseState copyWith({
//     AddCourseStatus? status,
//     int? currentStep,
//     String? selectedCategory,
//     String? selectedLevel,
//     List<String>? lessons,
//     String? courseThumbnail,
//     String? errorMessage,
//   }) {
//     return AddCourseState(
//       status: status ?? this.status,
//       currentStep: currentStep ?? this.currentStep,
//       selectedCategory: selectedCategory ?? this.selectedCategory,
//       selectedLevel: selectedLevel ?? this.selectedLevel,
//       lessons: lessons ?? this.lessons,
//       courseThumbnail: courseThumbnail ?? this.courseThumbnail,
//       errorMessage: errorMessage,
//     );
//   }
// }

// class AddCourseCubit extends Cubit<AddCourseState> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final priceController = TextEditingController();
//   final offerPercentageController = TextEditingController();

  

//   AddCourseCubit() : super(AddCourseState.initial());

//   @override
//   Future<void> close() {
//     titleController.dispose();
//     descriptionController.dispose();
//     priceController.dispose();
//     offerPercentageController.dispose();
//     return super.close();
//   }

//   void nextStep() {
//     if (state.currentStep < 3) {
//       emit(state.copyWith(currentStep: state.currentStep + 1));
//     }
//   }

//   void previousStep() {
//     if (state.currentStep > 0) {
//       emit(state.copyWith(currentStep: state.currentStep - 1));
//     }
//   }

//   void goToStep(int step) {
//     if (step >= 0 && step <= 3) {
//       emit(state.copyWith(currentStep: step));
//     }
//   }

//   void updateCategory(String category) {
//     emit(state.copyWith(selectedCategory: category));
//   }

//   void updateLevel(String level) {
//     emit(state.copyWith(selectedLevel: level));
//   }

//   void addLesson(String lessonId) {
//     final updatedLessons = List<String>.from(state.lessons)..add(lessonId);
//     emit(state.copyWith(lessons: updatedLessons));
//   }

//   void removeLesson(int index) {
//     if (index >= 0 && index < state.lessons.length) {
//       final updatedLessons = List<String>.from(state.lessons)..removeAt(index);
//       emit(state.copyWith(lessons: updatedLessons));
//     }
//   }

//   Future<void> uploadThumbnail() async {
//     emit(state.copyWith(status: AddCourseStatus.uploadingThumbnail, errorMessage: null));

//     final result = await _uploadThumbnailUseCase.call(params: NoParams());
//     result.fold(
//       (l) => emit(state.copyWith(
//         status: AddCourseStatus.failure,
//         errorMessage: 'Failed to upload thumbnail',
//       )),
//       (thumbnailUrl) => emit(state.copyWith(
//         status: AddCourseStatus.thumbnailUploaded,
//         courseThumbnail: "",
//       )),
//     );
//   }

//   Future<void> publishCourse(String tutorId) async {
//     if (!_validateForm()) return;

//     emit(state.copyWith(status: AddCourseStatus.submitting, errorMessage: null));

//     final courseParams = CourseParams(
//       title: titleController.text,
//       description: descriptionController.text,
//       categoryId: state.selectedCategory,
//       price: int.parse(priceController.text),
//       offerPercentage: int.parse(offerPercentageController.text),
//       tutorId: tutorId,
//       level: state.selectedLevel,
//       lessons: state.lessons,
//       courseThumbnail: state.courseThumbnail,
//     );

//     final result = await _createCourseUseCase.call(params: courseParams);

//     result.fold(
//       (l) => emit(state.copyWith(
//         status: AddCourseStatus.failure,
//         errorMessage: 'Failed to publish course',
//       )),
//       (_) => emit(state.copyWith(status: AddCourseStatus.submitted)),
//     );
//   }

//   bool _validateForm() {
//     String? error;

//     if (titleController.text.isEmpty) {
//       error = 'Title is required';
//     } else if (descriptionController.text.isEmpty) {
//       error = 'Description is required';
//     } else if (state.selectedCategory.isEmpty) {
//       error = 'Category is required';
//     } else if (priceController.text.isEmpty || int.tryParse(priceController.text) == null) {
//       error = 'Price must be a valid number';
//     } else if (offerPercentageController.text.isEmpty || int.tryParse(offerPercentageController.text) == null) {
//       error = 'Discount percentage must be a valid number';
//     } else if (int.parse(offerPercentageController.text) < 0 || int.parse(offerPercentageController.text) > 100) {
//       error = 'Discount must be between 0 and 100';
//     } else if (state.lessons.isEmpty) {
//       error = 'At least one lesson is required';
//     } else if (state.courseThumbnail.isEmpty) {
//       error = 'Course thumbnail is required';
//     }

//     if (error != null) {
//       emit(state.copyWith(status: AddCourseStatus.failure, errorMessage: error));
//       return false;
//     }

//     return true;
//   }

//   void clearError() {
//     emit(state.copyWith(errorMessage: null));
//   }

//   int calculateTotalDuration() {
//     return state.lessons.length * 20;
//   }
// }

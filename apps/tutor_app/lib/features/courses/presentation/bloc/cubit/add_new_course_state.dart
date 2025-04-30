
// class AddCourseState {
//   final int currentStep;
//   final String selectedCategory;
//   final String selectedLevel;
//   final List<String> lessons;
//   final String courseThumbnail;
//   final bool isSubmitting;
//   final bool isUploading;
//   final bool isSubmitSuccess;
//   final String errorMessage;

//   const AddCourseState({
//     required this.currentStep,
//     required this.selectedCategory,
//     required this.selectedLevel,
//     required this.lessons,
//     required this.courseThumbnail,
//     required this.isSubmitting,
//     required this.isUploading,
//     required this.isSubmitSuccess,
//     required this.errorMessage,
//   });

//   factory AddCourseState.initial() {
//     return const AddCourseState(
//       currentStep: 0,
//       selectedCategory: '',
//       selectedLevel: 'Beginner',
//       lessons: [],
//       courseThumbnail: '',
//       isSubmitting: false,
//       isUploading: false,
//       isSubmitSuccess: false,
//       errorMessage: '',
//     );
//   }

//   AddCourseState copyWith({
//     int? currentStep,
//     String? selectedCategory,
//     String? selectedLevel,
//     List<String>? lessons,
//     String? courseThumbnail,
//     bool? isSubmitting,
//     bool? isUploading,
//     bool? isSubmitSuccess,
//     String? errorMessage,
//   }) {
//     return AddCourseState(
//       currentStep: currentStep ?? this.currentStep,
//       selectedCategory: selectedCategory ?? this.selectedCategory,
//       selectedLevel: selectedLevel ?? this.selectedLevel,
//       lessons: lessons ?? this.lessons,
//       courseThumbnail: courseThumbnail ?? this.courseThumbnail,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       isUploading: isUploading ?? this.isUploading,
//       isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object> get props => [
//         currentStep,
//         selectedCategory,
//         selectedLevel,
//         lessons,
//         courseThumbnail,
//         isSubmitting,
//         isUploading,
//         isSubmitSuccess,
//         errorMessage,
//       ];
// }
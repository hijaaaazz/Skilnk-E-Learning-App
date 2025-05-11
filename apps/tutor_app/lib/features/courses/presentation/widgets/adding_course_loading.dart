// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
// import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
// import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

// class UploadStatusDialog extends StatelessWidget {
//   final Future<void> uploadTask;

//   const UploadStatusDialog({super.key, required this.uploadTask});

//   @override
//   Widget build(BuildContext context) {
//     // Get the theme colors
//     final deepOrange = Theme.of(context).brightness == Brightness.light
//         ? Colors.deepOrange
//         : Colors.deepOrange[300];
    
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 0,
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: BlocBuilder<AddCourseCubit, AddCourseState>(
//           builder: (context, state) {
//             if (state is CourseUploadLoading) {
//               return _buildLoadingState(context, state, deepOrange!);
//             } else if (state is CourseUploadSuccessStaete) {
//               return _buildSuccessState(context, deepOrange!);
//             } else if (state is CourseUploadErrorState) {
//               return _buildErrorState(context, state, deepOrange!);
//             }
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState(
//       BuildContext context, CourseUploadLoading state, Color deepOrange) {
//     final progress = uploadProgressToDouble(state.progress);
    
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 10),
//         Icon(
//           Icons.cloud_upload_rounded,
//           size: 48,
//           color: deepOrange,
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Uploading Course',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: deepOrange,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           state.message,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 24),
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             // Background progress bar
//             Container(
//               height: 10,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             // Actual progress
//             Align(
//               alignment: Alignment.centerLeft,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 height: 10,
//                 width: MediaQuery.of(context).size.width * 0.7 * progress,
//                 decoration: BoxDecoration(
//                   color: deepOrange,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Text(
//           '${(progress * 100).toInt()}%',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: deepOrange,
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildSuccessState(BuildContext context, Color deepOrange) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 10),
//         Icon(
//           Icons.check_circle_outline_rounded,
//           size: 64,
//           color: deepOrange,
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Course Uploaded Successfully!',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: deepOrange,
//           ),
//         ),
//         const SizedBox(height: 24),
//         Text(
//           'Your course is now available for students',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 24),
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: deepOrange,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//           child: const Text('OK'),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildErrorState(
//       BuildContext context, CourseUploadErrorState state, Color deepOrange) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 10),
//         Icon(
//           Icons.error_outline_rounded,
//           size: 64,
//           color: deepOrange,
//         ),
//         const SizedBox(height: 20),
//         Text(
//           'Upload Failed',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: deepOrange,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           state.error,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[700],
//           ),
//         ),
//         const SizedBox(height: 24),
//         ElevatedButton(
//           onPressed: () => Navigator.of(context).pop(),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: deepOrange,
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//           child: const Text('OK'),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
// }

// double uploadProgressToDouble(UploadProgress progress) {
//   switch (progress) {
//     case UploadProgress.started:
//       return 0.1;
//     case UploadProgress.thumbnailUploaded:
//       return 0.3;
//     case UploadProgress.lecturesUploading:
//       return 0.6;
//     case UploadProgress.lecturesUploaded:
//       return 0.8;
//     case UploadProgress.courseUploaded:
//       return 1.0;
//   }
// }

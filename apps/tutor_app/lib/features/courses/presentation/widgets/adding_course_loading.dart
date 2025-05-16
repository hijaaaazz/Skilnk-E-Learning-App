import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

class UploadStatusDialog extends StatefulWidget {
  

  const UploadStatusDialog({super.key,});

  @override
  State<UploadStatusDialog> createState() => _UploadStatusDialogState();
}



class _UploadStatusDialogState extends State<UploadStatusDialog> {
  @override
  void initState() {
    super.initState();

     Future.microtask(() async {
      try {
        // ignore: use_build_context_synchronously
        if (context.read<AddCourseCubit>().state.isEditing == true) {
            // ignore: use_build_context_synchronously
            await context.read<AddCourseCubit>().uploadEditedCourse(context);
          } else {
            // ignore: use_build_context_synchronously
            await context.read<AddCourseCubit>().uploadCourse(context.read<AuthBloc>().state.user!.tutorId,context);
          }

        // Optional: automatically close the dialog on success
        if (mounted) {
          final state = context.read<AddCourseCubit>().state;
          if (state is CourseUploadSuccessStaete) {
            Navigator.of(context).pop(); // Only if you want to auto-close
          }
        }
      } catch (e) {
        // Errors will be caught by the cubit, so no need to handle here
      }
    });
  }
  @override
  Widget build(BuildContext context) {

   
    // Get the theme colors
    final deepOrange = Theme.of(context).brightness == Brightness.light
        ? Colors.deepOrange
        : Colors.deepOrange[300];
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<AddCourseCubit, AddCourseState>(
          builder: (context, state) {
            if (state is CourseUploadLoading) {
              return _buildLoadingState(context, state, deepOrange!);
            } else if (state is CourseUploadSuccessStaete) {
              return _buildSuccessState(context, deepOrange!);
            } else if (state is CourseUploadErrorState) {
              return _buildErrorState(context, state, deepOrange!);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(
      BuildContext context, CourseUploadLoading state, Color deepOrange) {
    final progress = uploadProgressToDouble(state.progress);
    final progressText = getProgressText(state.progress);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Icon(
          getProgressIcon(state.progress),
          size: 48,
          color: deepOrange,
        ),
        const SizedBox(height: 20),
        Text(
          'Uploading Course',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: deepOrange,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          progressText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            // Background progress bar
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Actual progress
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 10,
                width: MediaQuery.of(context).size.width * 0.7 * progress,
                decoration: BoxDecoration(
                  color: deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: deepOrange,
          ),
        ),
        const SizedBox(height: 16),
        // Current step display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: deepOrange,
              ),
              const SizedBox(width: 8),
              Text(
                getCurrentStep(state.progress),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, Color deepOrange) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Icon(
          Icons.check_circle_outline_rounded,
          size: 64,
          color: deepOrange,
        ),
        const SizedBox(height: 20),
        Text(
          'Course Uploaded Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: deepOrange,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your course is now available for students',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: deepOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('OK'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildErrorState(
      BuildContext context, CourseUploadErrorState state, Color deepOrange) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Icon(
          Icons.error_outline_rounded,
          size: 64,
          color: deepOrange,
        ),
        const SizedBox(height: 20),
        Text(
          'Upload Failed',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: deepOrange,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          state.error,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: deepOrange,
                side: BorderSide(color: deepOrange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Trigger retry logic here
               
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Get appropriate icon for each progress state
  IconData getProgressIcon(UploadProgress progress) {
    switch (progress) {
      case UploadProgress.started:
        return Icons.file_upload_outlined;
      case UploadProgress.thumbnailUploaded:
        return Icons.image;
      case UploadProgress.lecturesUploading:
        return Icons.video_library;
      case UploadProgress.lecturesUploaded:
        return Icons.video_file;
      case UploadProgress.courseUploaded:
        return Icons.school;
    }
  }

  // Get detailed progress text for each state
  String getProgressText(UploadProgress progress) {
    switch (progress) {
      case UploadProgress.started:
        return 'Preparing your course files for upload. This may take a moment.';
      case UploadProgress.thumbnailUploaded:
        return 'Course thumbnail successfully uploaded. Now preparing lecture content.';
      case UploadProgress.lecturesUploading:
        return 'Uploading your lecture videos and materials. This may take several minutes depending on file size.';
      case UploadProgress.lecturesUploaded:
        return 'All lecture content uploaded. Finalizing course details.';
      case UploadProgress.courseUploaded:
        return 'Course upload complete! Saving to our database.';
    }
  }

  // Get current step description
  String getCurrentStep(UploadProgress progress) {
    switch (progress) {
      case UploadProgress.started:
        return 'Step 1: Initializing upload';
      case UploadProgress.thumbnailUploaded:
        return 'Step 2: Thumbnail uploaded';
      case UploadProgress.lecturesUploading:
        return 'Step 3: Uploading lectures';
      case UploadProgress.lecturesUploaded:
        return 'Step 4: Lectures uploaded';
      case UploadProgress.courseUploaded:
        return 'Step 5: Finalizing course';
    }
  }
}

double uploadProgressToDouble(UploadProgress progress) {
  switch (progress) {
    case UploadProgress.started:
      return 0.1;
    case UploadProgress.thumbnailUploaded:
      return 0.3;
    case UploadProgress.lecturesUploading:
      return 0.6;
    case UploadProgress.lecturesUploaded:
      return 0.8;
    case UploadProgress.courseUploaded:
      return 1.0;
  }
}
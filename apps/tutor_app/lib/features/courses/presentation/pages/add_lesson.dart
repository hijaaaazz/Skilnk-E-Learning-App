import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:tutor_app/common/widgets/app_text.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:go_router/go_router.dart';

class AddLecturePage extends StatefulWidget {
  const AddLecturePage({super.key});

  @override
  State<AddLecturePage> createState() => _AddLecturePageState();
}

class _AddLecturePageState extends State<AddLecturePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This tracker helps identify when we need to reinitialize controllers
  int? _lastEditingIndex;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCourseCubit, AddCourseState>(
      builder: (context, state) {
        // Initialize controllers when the editing index changes or is newly set/cleared
        if (_lastEditingIndex != state.editingLectureIndex) {
          _lastEditingIndex = state.editingLectureIndex;

          // Reset controllers first
          _titleController.clear();
          _descriptionController.clear();

          // Then populate if in edit mode
          if (state.editingLectureIndex != null) {
            final lecture = state.lessons[state.editingLectureIndex!];
            _titleController.text = lecture.title ?? '';
            _descriptionController.text = lecture.description ?? '';
          }
        }

        final isEditing = state.editingLectureIndex != null;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Lecture' : 'Add New Lecture'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (isEditing) {
                  context.read<AddCourseCubit>().cancelEditing();
                } else {
                  context.read<AddCourseCubit>().resetFileSelection();
                }
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title input
                const AppText(text: 'Lecture Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter lecture title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Description input
                const AppText(text: 'Description (Optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter lecture description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Video upload section
                const AppText(text: 'Upload Video'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _pickVideo(context),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library,
                          size: 48,
                          color: state.selectedVideoPath != null &&
                                  state.selectedVideoPath!.isNotEmpty
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            state.selectedVideoPath != null &&
                                    state.selectedVideoPath!.isNotEmpty
                                ? kIsWeb
                                    ? 'Video Selected'
                                    : path.basename(state.selectedVideoPath!)
                                : 'Select video file',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: state.selectedVideoPath != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // PDF upload section
                const AppText(text: 'Upload PDF Notes (Optional)'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _pickPdf(context),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 48,
                          color: state.selectedPdfPath != null &&
                                  state.selectedPdfPath!.isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            state.selectedPdfPath != null &&
                                    state.selectedPdfPath!.isNotEmpty
                                ? kIsWeb
                                    ? 'PDF Selected'
                                    : path.basename(state.selectedPdfPath!)
                                : 'Select PDF file',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: state.selectedPdfPath != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveLecture(context, state),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      isEditing ? 'Update Lecture' : 'Save Lecture',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pickVideo(BuildContext context) async {
    log("Picking video file");
    final cubit = context.read<AddCourseCubit>();
    final videoPath = await cubit.pickVideoFile(context);

    if (videoPath != null) {
      log("Selected video file: $videoPath");
      cubit.updateSelectedVideoPath(videoPath,
          bytes: kIsWeb ? cubit.state.selectedVideoBytes : null);
    } else {
      log("No video file was selected");
    }
  }

  void _pickPdf(BuildContext context) async {
    log("Picking PDF file");
    final cubit = context.read<AddCourseCubit>();
    final pdfPath = await cubit.pickPdfFile(context);

    if (pdfPath != null) {
      log("Selected PDF file: $pdfPath");
      cubit.updateSelectedPdfPath(pdfPath,
          bytes: kIsWeb ? cubit.state.selectedPdfBytes : null);
    } else {
      log("No PDF file was selected");
    }
  }

  void _saveLecture(BuildContext context, AddCourseState state) {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final videoPath = state.selectedVideoPath;
    final pdfPath = state.selectedPdfPath;
    final cubit = context.read<AddCourseCubit>();

    // Validate title
    if (title.isEmpty) {
      showAppSnackbar(context, "Please enter a lecture title");
      return;
    }

    // Validate video path
    if (videoPath == null || videoPath.isEmpty) {
      showAppSnackbar(context, "Please select a video file");
      return;
    }

    if (state.editingLectureIndex != null) {
      // We're in edit mode
      log("Updating lecture at index ${state.editingLectureIndex}");
      cubit.updateLecture(
        title: title,
        description: description.isNotEmpty ? description : null,
        videoPath: videoPath,
        pdfPath: pdfPath,
        videoBytes: kIsWeb ? state.selectedVideoBytes : null,
        pdfBytes: kIsWeb ? state.selectedPdfBytes : null,
      );
      showAppSnackbar(context, "Lecture updated successfully");
    } else {
      // We're in add mode
      log("Adding new lecture");
      cubit.addLectureWithFiles(
        title: title,
        description: description.isNotEmpty ? description : null,
        videoPath: videoPath,
        pdfPath: pdfPath,
        videoBytes: kIsWeb ? state.selectedVideoBytes : null,
        pdfBytes: kIsWeb ? state.selectedPdfBytes : null,
      );
      showAppSnackbar(context, "Lecture added successfully");
    }

    context.pop();
  }
}
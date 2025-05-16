import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin FileSelectionHandlers on Cubit<AddCourseState> {
  void updateSelectedVideoPath(String path) {
    try {
      if (isClosed) return;
      if (path.isEmpty) {
        log("Warning: Empty video path provided");
        return;
      }
      final file = File(path);
      if (!file.existsSync()) {
        log("Warning: Video file does not exist: $path");
      }
      emit(state.copyWith(selectedVideoPath: path));
      log("Selected video path updated: $path");
    } catch (e) {
      log("Error updating selected video path: $e");
    }
  }

  void updateSelectedPdfPath(String? path) {
    try {
      if (isClosed) return;
      if (path != null && path.isEmpty) {
        log("Warning: Empty PDF path provided");
        path = null;
      } else if (path != null) {
        final file = File(path);
        if (!file.existsSync()) {
          log("Warning: PDF file does not exist: $path");
        }
      }
      emit(state.copyWith(selectedPdfPath: path));
      log("Selected PDF path updated: $path");
    } catch (e) {
      log("Error updating selected PDF path: $e");
    }
  }

  void resetFileSelection() {
    try {
      if (isClosed) return;
      emit(state.copyWith(
        selectedVideoPath: null,
        selectedPdfPath: null,
      ));
      log("File selection reset");
    } catch (e) {
      log("Error resetting file selection: $e");
    }
  }

  void clearLessonTempData() {
    emit(state.copyWith(
      currentLessonTitle: "",
      selectedVideoPath: null,
      selectedPdfPath: null,
      editingLectureIndex: null,
    ));
  }

  Future<String?> pickVideoFile(BuildContext context) async {
    try {
      log("Opening file picker for video");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: false,
        withReadStream: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final String? filePath = result.files.first.path;
        if (filePath != null && filePath.isNotEmpty) {
          final File file = File(filePath);
          if (await file.exists()) {
            log("Video file selected: $filePath");
            return filePath;
          } else {
            log("Selected video file not found: $filePath");
            // ignore: use_build_context_synchronously
            showAppSnackbar(context, "Selected video file not found");
          }
        }
      }
      return null;
    } catch (e) {
      log("Error picking video file: $e");
      // ignore: use_build_context_synchronously
      showAppSnackbar(context, "Could not select video file");
      return null;
    }
  }

  Future<String?> pickPdfFile(BuildContext context) async {
    try {
      log("Opening file picker for PDF");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: false,
        withReadStream: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final String? filePath = result.files.first.path;
        if (filePath != null && filePath.isNotEmpty) {
          final File file = File(filePath);
          if (await file.exists()) {
            log("PDF file selected: $filePath");
            return filePath;
          } else {
            log("Selected PDF file not found: $filePath");
            // ignore: use_build_context_synchronously
            showAppSnackbar(context, "Selected PDF file not found");
          }
        }
      }
      return null;
    } catch (e) {
      log("Error picking PDF file: $e");
      // ignore: use_build_context_synchronously
      showAppSnackbar(context, "Could not select PDF file");
      return null;
    }
  }
}

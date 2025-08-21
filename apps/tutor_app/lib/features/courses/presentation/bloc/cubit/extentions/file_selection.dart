import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin FileSelectionHandlers on Cubit<AddCourseState> {
  void updateSelectedVideoPath(String path, {Uint8List? bytes}) {
    try {
      if (isClosed) return;
      if (path.isEmpty) {
        log("Warning: Empty video path provided");
        return;
      }
      if (!kIsWeb) {
        final file = File(path);
        if (!file.existsSync()) {
          log("Warning: Video file does not exist: $path");
          return;
        }
      }
      emit(state.copyWith(
        selectedVideoPath: path,
        selectedVideoBytes: bytes,
      ));
      log("Selected video path updated: $path${bytes != null ? ', with bytes' : ''}");
    } catch (e) {
      log("Error updating selected video path: $e");
    }
  }

  void updateSelectedPdfPath(String? path, {Uint8List? bytes}) {
    try {
      if (isClosed) return;
      if (path != null && path.isEmpty) {
        log("Warning: Empty PDF path provided");
        path = null;
      } else if (path != null && !kIsWeb) {
        final file = File(path);
        if (!file.existsSync()) {
          log("Warning: PDF file not found: $path");
          path = null;
        }
      }
      emit(state.copyWith(
        selectedPdfPath: path,
        selectedPdfBytes: bytes,
      ));
      log("Selected PDF path updated: $path${bytes != null ? ', with bytes' : ''}");
    } catch (e) {
      log("Error updating selected PDF path: $e");
    }
  }

  void resetFileSelection() {
    try {
      if (isClosed) return;
      emit(state.copyWith(
        selectedVideoPath: null,
        selectedVideoBytes: null,
        selectedPdfPath: null,
        selectedPdfBytes: null,
      ));
      log("File selection reset");
    } catch (e) {
      log("Error resetting file selection: $e");
    }
  }

  void clearLessonTempData() {
    try {
      if (isClosed) return;
      emit(state.copyWith(
        currentLessonTitle: "",
        selectedVideoPath: null,
        selectedVideoBytes: null,
        selectedPdfPath: null,
        selectedPdfBytes: null,
        editingLectureIndex: null,
      ));
      log("Lesson temp data cleared");
    } catch (e) {
      log("Error clearing lesson temp data: $e");
    }
  }

  Future<String?> pickVideoFile(BuildContext context) async {
    try {
      log("Opening file picker for video");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb,
        withReadStream: !kIsWeb,
      );
      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        if (kIsWeb) {
          if (platformFile.bytes != null) {
            final base64Video = "data:video/mp4;base64,${base64Encode(platformFile.bytes!)}";
            updateSelectedVideoPath(base64Video, bytes: platformFile.bytes);
            log("Web video selected: $base64Video");
            return base64Video;
          } else {
            log("No bytes found for web video");
            // ignore: use_build_context_synchronously
            showAppSnackbar(context, "Failed to read video file");
            return null;
          }
        } else {
          final filePath = platformFile.path;
          if (filePath != null && filePath.isNotEmpty) {
            final file = File(filePath);
            if (await file.exists()) {
              updateSelectedVideoPath(filePath);
              log("Mobile video selected: $filePath");
              return filePath;
            } else {
              log("Selected video file not found: $filePath");
              // ignore: use_build_context_synchronously
              showAppSnackbar(context, "Selected video file not found");
              return null;
            }
          }
        }
      }
      log("No video file selected");
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
        withData: kIsWeb,
        withReadStream: !kIsWeb,
      );
      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        if (kIsWeb) {
          if (platformFile.bytes != null) {
            final base64Pdf = "data:application/pdf;base64,${base64Encode(platformFile.bytes!)}";
            updateSelectedPdfPath(base64Pdf, bytes: platformFile.bytes);
            log("Web PDF selected: $base64Pdf");
            return base64Pdf;
          } else {
            log("No bytes found for web PDF");
            showAppSnackbar(context, "Failed to read PDF file");
            return null;
          }
        } else {
          final filePath = platformFile.path;
          if (filePath != null && filePath.isNotEmpty) {
            final file = File(filePath);
            if (await file.exists()) {
              updateSelectedPdfPath(filePath);
              log("Mobile PDF selected: $filePath");
              return filePath;
            } else {
              log("Selected PDF file not found: $filePath");
              showAppSnackbar(context, "Selected PDF file not found");
              return null;
            }
          }
        }
      }
      log("No PDF file selected");
      return null;
    } catch (e) {
      log("Error picking PDF file: $e");
      showAppSnackbar(context, "Could not select PDF file");
      return null;
    }
  }
}
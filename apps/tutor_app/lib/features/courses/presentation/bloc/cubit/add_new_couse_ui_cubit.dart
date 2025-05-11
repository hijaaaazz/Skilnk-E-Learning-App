import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tutor_app/common/widgets/snack_bar.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/core/utils/get_video_duration.dart';
import 'package:tutor_app/core/utils/image_cropper.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/service_locator.dart';

class AddCourseCubit extends Cubit<AddCourseState> {
  AddCourseCubit() : super(const AddCourseState());

  // =================== API METHODS ===================

  Future<void> loadCourseOptions() async {
    emit(state.copyWith(isOptionsLoading: true, optionsError: null));

    final result = await serviceLocator<GetCourseOptionsUseCase>().call(params: NoParams());

    result.fold(
      (error) {
        emit(state.copyWith(
          isOptionsLoading: false,
          optionsError: error,
        ));
      },
      (data) {
        emit(state.copyWith(
          isOptionsLoading: false,
          options: data,
        ));
      },
    );
  }

  // =================== COURSE BASIC INFO METHODS ===================
  
  void updateTitle(String title) {
    emit(state.copyWith(
      title: title,
      titleError: _validateTitle(title),
    ));
  }
  
  void updateIsPaid(bool isPaid) {
    emit(state.copyWith(isPaid: isPaid,));
  }

  void updatePrice(String price) {
    emit(state.copyWith(
      price: price,
      priceError: _validatePrice(price),
    ));
  }

  void updateCategory(CategoryEntity? category) {
    emit(state.copyWith(
      category: category,
      categoryError: _validateCategory(category),
    ));
  }

  void updateLanguage(String? language) {
    emit(state.copyWith(
      language: language,
      languageError: language == null || language.isEmpty 
          ? "Please select a language" 
          : null,
    ));
  }

  void updateLevel(String? level) {
    emit(state.copyWith(
      level: level,
      levelError: level == null || level.isEmpty 
          ? "Please select a level" 
          : null,
    ));
  }

  // =================== COURSE ADVANCED INFO METHODS ===================
  
  void updateDescription(String description) {
    emit(state.copyWith(
      description: description,
      descriptionError: description.isEmpty ? "Description is required" : null,
    ));
  }

  Future<void> pickThumbnail() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Step 1: Pick image from gallery
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        // Specify lower resolution to avoid graphics issues
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // Step 2: Launch native crop page
        try {
          final CroppedFile? croppedFile = await croppedImage(pickedFile);

          if (croppedFile != null) {
            // Step 3: Update thumbnail path to show in UI
            updateThumbnailPath(croppedFile.path);
          }
        } catch (cropError) {
          log("Error cropping image: $cropError");
          // If cropping fails, use the original image
          updateThumbnailPath(pickedFile.path);
        }
      }
    } catch (e) {
      log("Error picking thumbnail: $e");
      // Do not update state or show error to avoid crashing the UI
    }
  }

  void updateThumbnailPath(String path) {
    try {
      // Verify the file exists and is readable
      final file = File(path);
      if (!file.existsSync()) {
        log("Warning: Thumbnail file does not exist: $path");
        // Continue anyway but log the warning
      }
      emit(state.copyWith(thumbnailPath: path));
    } catch (e) {
      log("Error updating thumbnail path: $e");
      // Keep the current path if there's an error
    }
  }

  // =================== LECTURE MANAGEMENT METHODS ===================

  void updateCurrentLessonTitle(String title) {
    emit(state.copyWith(currentLessonTitle: title));
  }

  void addLesson() {
    if (state.currentLessonTitle.isNotEmpty) {
      final updatedLessons = List<LectureCreationReq>.from(state.lessons);
      
      emit(state.copyWith(
        lessons: updatedLessons,
        currentLessonTitle: '',
      ));
    }
  }

  Future<void> addLectureWithFiles({
    required String title,
    required String videoPath,
    String? description,
    String? pdfPath,
  }) async {
    try {
      log("Adding lecture with files: title=$title, video=$videoPath, pdf=$pdfPath");
      
      if (title.isNotEmpty && videoPath.isNotEmpty) {
        // Verify video file exists
        final videoFile = File(videoPath);
        if (!videoFile.existsSync()) {
          log("Warning: Video file does not exist: $videoPath");
          return;
        }
        
        // Check PDF file if provided
        if (pdfPath != null && pdfPath.isNotEmpty) {
          final pdfFile = File(pdfPath);
          if (!pdfFile.existsSync()) {
            log("Warning: PDF file does not exist: $pdfPath");
            // Continue without PDF
            pdfPath = null;
          }
        }

        // Get video duration using the utility method
        Duration? duration = await _getVideoFileDuration(videoPath);
        if (duration == null) {
          log("Warning: Could not get video duration for: $videoPath");
          // Continue with null duration
        }

        final newLecture = LectureCreationReq(
          title: title,
          description: description ?? '',
          videoUrl: videoPath,
          notesUrl: pdfPath,
          duration: duration,
        );

        // Always create a new list to ensure state update is detected
        final updatedLessons = List<LectureCreationReq>.from(state.lessons)..add(newLecture);
        
        // Calculate total course duration
        final totalDuration = _calculateTotalDuration(updatedLessons);
        
        emit(state.copyWith(
          lessons: updatedLessons,
          courseDuration: totalDuration,
          // Reset selected files after adding lecture
          selectedVideoPath: null,
          selectedPdfPath: null,
          editingLectureIndex: null, // Make sure to reset editing index to null
        ));
        
        log("Added lecture: ${newLecture.title}, lessons count: ${updatedLessons.length}");
        log("Total course duration: ${totalDuration?.inMinutes} minutes");
        log("Reset file selections to null");
      } else {
        log("Failed to add lecture: title or videoPath is empty");
      }
    } catch (e) {
      log("Error adding lecture: $e");
      // Don't update state if there's an error
    }
  }

  void removeLecture(int index) {
    try {
      if (index >= 0 && index < state.lessons.length) {
        final updatedLessons = List<LectureCreationReq>.from(state.lessons);
        updatedLessons.removeAt(index);
        
        // Recalculate total course duration
        final totalDuration = _calculateTotalDuration(updatedLessons);
        
        emit(state.copyWith(
          lessons: updatedLessons,
          courseDuration: totalDuration,
          // Clear editing state if the lecture being edited is removed
          editingLectureIndex: state.editingLectureIndex == index ? null : state.editingLectureIndex,
          selectedVideoPath: state.editingLectureIndex == index ? null : state.selectedVideoPath,
          selectedPdfPath: state.editingLectureIndex == index ? null : state.selectedPdfPath,
        ));
        log("Removed lecture at index $index, lessons count: ${updatedLessons.length}");
        log("Updated total course duration: ${totalDuration?.inMinutes} minutes");
      }
    } catch (e) {
      log("Error removing lecture: $e");
    }
  }

  void reorderLectures(int oldIndex, int newIndex) {
    try {
      if (oldIndex < 0 || oldIndex >= state.lessons.length || 
          newIndex < 0 || newIndex > state.lessons.length) {
        return;
      }
      
      final updatedLessons = List<LectureCreationReq>.from(state.lessons);
      
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      
      final lecture = updatedLessons.removeAt(oldIndex);
      updatedLessons.insert(newIndex, lecture);
      
      // Update editing index if necessary
      int? newEditingIndex = state.editingLectureIndex;
      if (state.editingLectureIndex != null) {
        if (state.editingLectureIndex == oldIndex) {
          newEditingIndex = newIndex;
        } else if (oldIndex < state.editingLectureIndex! && newIndex >= state.editingLectureIndex!) {
          newEditingIndex = state.editingLectureIndex! - 1;
        } else if (oldIndex > state.editingLectureIndex! && newIndex <= state.editingLectureIndex!) {
          newEditingIndex = state.editingLectureIndex! + 1;
        }
      }
      
      // No need to recalculate duration for reordering - the total duration remains the same
      
      emit(state.copyWith(
        lessons: updatedLessons,
        editingLectureIndex: newEditingIndex,
      ));
      log("Reordered lecture from index $oldIndex to $newIndex");
    } catch (e) {
      log("Error reordering lectures: $e");
    }
  }

  // =================== FILE SELECTION METHODS ===================

  void updateSelectedVideoPath(String path) {
    try {
      if (isClosed) return;
      
      // Verify path is not empty
      if (path.isEmpty) {
        log("Warning: Empty video path provided");
        return;
      }
      
      // Verify file exists
      final file = File(path);
      if (!file.existsSync()) {
        log("Warning: Video file does not exist: $path");
        // Continue anyway but log the warning
      }
      
      emit(state.copyWith(selectedVideoPath: path));
      log("Selected video path updated: $path");
      log("Current files - Video: $path, PDF: ${state.selectedPdfPath}");
    } catch (e) {
      log("Error updating selected video path: $e");
    }
  }

  void updateSelectedPdfPath(String? path) {
    try {
      if(isClosed) return;
      
      // If path is not null, verify it's not empty and file exists
      if (path != null) {
        if (path.isEmpty) {
          log("Warning: Empty PDF path provided");
          path = null;
        } else {
          // Verify file exists
          final file = File(path);
          if (!file.existsSync()) {
            log("Warning: PDF file does not exist: $path");
            // Continue anyway but log the warning
          }
        }
      }
      
      emit(state.copyWith(selectedPdfPath: path));
      log("Selected PDF path updated: $path");
      log("Current files - Video: ${state.selectedVideoPath}, PDF: $path");
    } catch (e) {
      log("Error updating selected PDF path: $e");
    }
  }

  void resetFileSelection() {
    try {
      log("Resetting file selection");
      if (isClosed) {
        log("Warning: Attempted to reset file selection but cubit was closed");
        return;
      }
      
      // Only reset file paths, but maintain editing index if in edit mode
      emit(state.copyWith(
        selectedVideoPath: null,
        selectedPdfPath: null,
      ));
      log("File selection reset - videoPath: ${state.selectedVideoPath}, pdfPath: ${state.selectedPdfPath}");
    } catch (e) {
      log("Error resetting file selection: $e");
    }
  }
  
  void clearLessonTempdata() {
    emit(state.copyWith(
      selectedVideoPath: null, 
      selectedPdfPath: null,
      editingLectureIndex: null, // Ensure editing state is cleared
    ));
  }

  // =================== FILE PICKER METHODS ===================

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
            showAppSnackbar(context, "Selected video file not found");
          }
        } else {
          log("File picker returned null or empty path");
        }
      } else {
        log("No file was selected or file picker was canceled");
      }
      return null;
    } catch (e) {
      log("Error picking video file: $e");
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
            showAppSnackbar(context, "Selected PDF file not found");
          }
        } else {
          log("File picker returned null or empty path");
        }
      } else {
        log("No file was selected or file picker was canceled");
      }
      return null;
    } catch (e) {
      log("Error picking PDF file: $e");
      showAppSnackbar(context, "Could not select PDF file");
      return null;
    }
  }

  // =================== VALIDATION METHODS ===================

  void clearValidationErrors() {
    emit(state.copyWith(
      titleError: null,
      categoryError: null,
      languageError: null,
      levelError: null,
      descriptionError: null,
      thumbnailError: null
    ));
  }

  String? _validateTitle(String title) {
    if (title.isEmpty) {
      return "Title is required";
    } else if (title.length < 5) {
      return "Title must be at least 5 characters";
    } else {
      return "";
    }
  }

  String? _validateCategory(CategoryEntity? category) {
    return category == null ? "Please select a category" : "";
  }

  String _validatePrice(String price) {
    if (state.isPaid) {
      if (price.isEmpty) {
        return 'Price is required for paid courses';
      }

      final parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        return 'Invalid price format';
      }

      if (parsedPrice <= 1) {
        return 'Price must be more than 1';
      }
    }

    return ""; // No error
  }

  bool validateBasicInfo() {
    try {
      final titleError = _validateTitle(state.title);
      final categoryError = _validateCategory(state.category);
      
      // Handle price validation properly for null values
      String? priceError;
      if (state.isPaid) {
        priceError = _validatePrice(state.price ?? '');
      } else {
        priceError = '';  // No error for free courses
      }
      
      final languageError = state.language == null || state.language!.isEmpty
          ? "Please select a language"
          : "";
      final levelError = state.level == null || state.level!.isEmpty
          ? "Please select a level" 
          : "";

      emit(state.copyWith(
        titleError: titleError,
        categoryError: categoryError,
        priceError: priceError,
        languageError: languageError,
        levelError: levelError,
      ));

      return titleError!.isEmpty && priceError.isEmpty && categoryError!.isEmpty && languageError.isEmpty && levelError.isEmpty;
    } catch (e) {
      log("Error validating basic info: $e");
      return false;
    }
  }

  bool validateAdvancedInfo(BuildContext context) {
    try {
      bool isValid = true;

      if (state.thumbnailPath.isEmpty) {
        showAppSnackbar(context, "Please select a thumbnail");
        emit(state.copyWith(thumbnailError: "Please select a thumbnail"));
        isValid = false;
      } else {
        // Verify the thumbnail file exists
        final file = File(state.thumbnailPath);
        if (!file.existsSync()) {
          showAppSnackbar(context, "Thumbnail file not found. Please select again.");
          emit(state.copyWith(thumbnailError: "Thumbnail file not found"));
          isValid = false;
        } else {
          emit(state.copyWith(thumbnailError: null));
        }
      }

      if (state.description.trim().isEmpty) {
        emit(state.copyWith(descriptionError: "Description is required"));
        isValid = false;
      } else {
        emit(state.copyWith(descriptionError: null));
      }

      return isValid;
    } catch (e) {
      log("Error validating advanced info: $e");
      showAppSnackbar(context, "An error occurred during validation");
      return false;
    }
  }

  bool validateCurriculum(BuildContext context) {
    try {
      if (state.lessons.isEmpty) {
        showAppSnackbar(context, "Please add at least one lecture to your course");
        return false;
      }
      
      // Additional validation to verify all video files still exist
      for (int i = 0; i < state.lessons.length; i++) {
        final lecture = state.lessons[i];
        
        // Check if videoUrl is null or empty
        if (lecture.videoUrl == null || lecture.videoUrl!.isEmpty) {
          showAppSnackbar(context, "Lecture '${lecture.title}' has no video. Please add it again.");
          return false;
        }
        
        final videoFile = File(lecture.videoUrl!);
        if (!videoFile.existsSync()) {
          showAppSnackbar(context, "Video for lecture '${lecture.title}' not found. Please add it again.");
          return false;
        }
        
        // Check PDF if present
        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          final pdfFile = File(lecture.notesUrl!);
          if (!pdfFile.existsSync()) {
            showAppSnackbar(context, "PDF notes for lecture '${lecture.title}' not found.");
            // Consider this a warning, not an error
          }
        }
      }
      
      return true;
    } catch (e) {
      log("Error validating curriculum: $e");
      showAppSnackbar(context, "An error occurred while checking your lectures");
      return false;
    }
  }

  // =================== UTILITY METHODS ===================

  void getCourseCreationReq() {
    log('''Creating course request: 
      title=${state.title},
      category=${state.category?.id},
      language=${state.language},
      level=${state.level}
      description=${state.description}
      total duration=${state.courseDuration?.inMinutes} minutes
    ''');
  }

  void startEditingLecture(int index) {
    final lecture = state.lessons[index];
    emit(state.copyWith(
      selectedVideoPath: lecture.videoUrl,
      selectedPdfPath: lecture.notesUrl,
      editingLectureIndex: index,
    ));
    log("Started editing lecture at index $index");
  }

  Future<void> updateLecture({
    required String title,
    String? description,
    required String videoPath,
    String? pdfPath,
  }) async {
    try {
      if (state.editingLectureIndex == null) {
        log("Cannot update lecture: No lecture is being edited");
        return; // Not in editing mode
      }
      
      log("Updating lecture at index ${state.editingLectureIndex}");
      
      // Get video duration using the utility method
      Duration? duration = await _getVideoFileDuration(videoPath);
      if (duration == null) {
        log("Warning: Could not get video duration for updated video: $videoPath");
      }
      
      final updatedLectures = List<LectureCreationReq>.from(state.lessons);
      updatedLectures[state.editingLectureIndex!] = LectureCreationReq(
        title: title,
        description: description,
        videoUrl: videoPath,
        notesUrl: pdfPath,
        duration: duration,
      );
      
      // Recalculate total course duration
      final totalDuration = _calculateTotalDuration(updatedLectures);
      
      emit(state.copyWith(
        lessons: updatedLectures,
        courseDuration: totalDuration,
        selectedVideoPath: null,
        selectedPdfPath: null,
        editingLectureIndex: null, // Clear editing state
      ));
      
      log("Lecture updated and editing state cleared");
      log("Updated total course duration: ${totalDuration?.inMinutes} minutes");
    } catch (e) {
      log("Error updating lecture: $e");
    }
  }

  // Helper method to get video duration from a file
  Future<Duration?> _getVideoFileDuration(String path) async {
    try {
      // Use the imported utility function instead of calling self
      return await getVideoDuration(path);
    } catch (e) {
      log("Error getting video duration: $e");
      return null;
    }
  }

  // Helper method to calculate total course duration
  Duration? _calculateTotalDuration(List<LectureCreationReq> lectures) {
    if (lectures.isEmpty) return null;
    
    int totalSeconds = 0;
    
    for (final lecture in lectures) {
      if (lecture.duration != null) {
        totalSeconds += lecture.duration!.inSeconds;
      }
    }
    
    return totalSeconds > 0 ? Duration(seconds: totalSeconds) : null;
  }

  void cancelEditing() {
    log("Canceling lecture editing");
    emit(state.copyWith(
      selectedVideoPath: null,
      selectedPdfPath: null,
      editingLectureIndex: null, // Clear editing state
    ));
    log("Editing state cleared");
  }

  // =================== PUBLISH METHODS ===================
  
  Future<void> uploadCourse(String tutorId) async {
    log("Started uploading course");
    
    try {
      // Calculate total duration one more time to ensure it's up-to-date
      final totalDuration = _calculateTotalDuration(state.lessons);
      
      final courseReq = CourseCreationReq(
        title: state.title,
        description: state.description,
        isPaid: state.isPaid,
        categoryId: state.category?.id,
        price: state.isPaid ? int.tryParse(state.price ?? '0') : 0,
        language: state.language,
        level: state.level,
        duration: totalDuration,
        lectures: state.lessons,
        tutorId: tutorId,
        courseThumbnail: state.thumbnailPath,
      );
      
      final result = await serviceLocator<CreateCourseUseCase>().call(params: courseReq);
      
      result.fold(
        (error) {
          log("Course upload failed: $error");
          // Handle error, could update state or show error message
        },
        (data) {
          log("Course upload successful: $data");
          // Handle success, could navigate to course page or show success message
        },
      );
    } catch (e) {
      log("Error uploading course: $e");
      // Handle unexpected errors
    }
  }
}
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/utils/get_video_duration.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin LectureManagementHandlers on Cubit<AddCourseState> {
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
        final videoFile = File(videoPath);
        if (!videoFile.existsSync()) {
          log("Warning: Video file does not exist: $videoPath");
          return;
        }
        if (pdfPath != null && pdfPath.isNotEmpty) {
          final pdfFile = File(pdfPath);
          if (!pdfFile.existsSync()) {
            log("Warning: PDF file does not exist: $pdfPath");
            pdfPath = null;
          }
        }
        final duration = await getVideoDuration(videoPath);
        final newLecture = LectureCreationReq(
          title: title,
          description: description ?? '',
          videoUrl: videoPath,
          notesUrl: pdfPath,
          duration: duration,
        );
        final updatedLessons = List<LectureCreationReq>.from(state.lessons)..add(newLecture);
        final totalDuration = calculateTotalDuration(updatedLessons);
        emit(state.copyWith(
          lessons: updatedLessons,
          courseDuration: totalDuration,
          selectedVideoPath: null,
          selectedPdfPath: null,
          editingLectureIndex: null,
        ));
        log("Added lecture: ${newLecture.title}, lessons count: ${updatedLessons.length}");
      } else {
        log("Failed to add lecture: title or videoPath is empty");
      }
    } catch (e) {
      log("Error adding lecture: $e");
    }
  }

  void removeLecture(int index) {
    try {
      if (index >= 0 && index < state.lessons.length) {
        final updatedLessons = List<LectureCreationReq>.from(state.lessons)..removeAt(index);
        final totalDuration = calculateTotalDuration(updatedLessons);
        emit(state.copyWith(
          lessons: updatedLessons,
          courseDuration: totalDuration,
          editingLectureIndex: state.editingLectureIndex == index ? null : state.editingLectureIndex,
          selectedVideoPath: state.editingLectureIndex == index ? null : state.selectedVideoPath,
          selectedPdfPath: state.editingLectureIndex == index ? null : state.selectedPdfPath,
        ));
        log("Removed lecture at index $index, lessons count: ${updatedLessons.length}");
      }
    } catch (e) {
      log("Error removing lecture: $e");
    }
  }

  void reorderLectures(int oldIndex, int newIndex) {
    try {
      if (oldIndex < 0 || oldIndex >= state.lessons.length || newIndex < 0 || newIndex > state.lessons.length) {
        return;
      }
      final updatedLessons = List<LectureCreationReq>.from(state.lessons);
      if (oldIndex < newIndex) newIndex -= 1;
      final lecture = updatedLessons.removeAt(oldIndex);
      updatedLessons.insert(newIndex, lecture);
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
      emit(state.copyWith(
        lessons: updatedLessons,
        editingLectureIndex: newEditingIndex,
      ));
      log("Reordered lecture from index $oldIndex to $newIndex");
    } catch (e) {
      log("Error reordering lectures: $e");
    }
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
        return;
      }
      final duration = await getVideoDuration(videoPath);
      final updatedLectures = List<LectureCreationReq>.from(state.lessons);
      updatedLectures[state.editingLectureIndex!] = LectureCreationReq(
        title: title,
        description: description,
        videoUrl: videoPath,
        notesUrl: pdfPath,
        duration: duration,
      );
      final totalDuration = calculateTotalDuration(updatedLectures);
      emit(state.copyWith(
        lessons: updatedLectures,
        courseDuration: totalDuration,
        selectedVideoPath: null,
        selectedPdfPath: null,
        editingLectureIndex: null,
      ));
      log("Lecture updated and editing state cleared");
    } catch (e) {
      log("Error updating lecture: $e");
    }
  }

  void cancelEditing() {
    log("Canceling lecture editing");
    emit(state.copyWith(
      selectedVideoPath: null,
      selectedPdfPath: null,
      editingLectureIndex: null,
    ));
    log("Editing state cleared");
  }

   Duration? calculateTotalDuration(List<LectureCreationReq> lectures) {
    if (lectures.isEmpty) return null;
    
    int totalSeconds = 0;
    
    for (final lecture in lectures) {
      if (lecture.duration != null) {
        totalSeconds += lecture.duration!.inSeconds;
      }
    }
    
    return totalSeconds > 0 ? Duration(seconds: totalSeconds) : null;
  }
}
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/utils/get_video_duration.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';

mixin UtilityHandlers on Cubit<AddCourseState> {
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

  Future<Duration?> getVideoFileDuration(String path) async {
    try {
      return await getVideoDuration(path);
    } catch (e) {
      log("Error getting video duration: $e");
      return null;
    }
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
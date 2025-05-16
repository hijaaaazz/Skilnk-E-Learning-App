import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
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


}

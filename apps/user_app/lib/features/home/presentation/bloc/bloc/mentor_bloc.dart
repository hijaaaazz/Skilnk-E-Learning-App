import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/domain/usecases/get_mentor_courses.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/mentor_event.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/mentor_state.dart';
import 'package:user_app/service_locator.dart';

class MentorDetailsBloc extends Bloc<MentorDetailsEvent, MentorDetailsState> {
  MentorDetailsBloc() : super(MentorDetailsInitial()) {
    on<LoadMentorDetails>(_onLoadMentorDetails);
    on<ChatWithMentor>(_onChatWithMentor);
    on<LoadMentorCourses>(_onLoadMentorCourses);
  }

  void _onLoadMentorDetails(
    LoadMentorDetails event,
    Emitter<MentorDetailsState> emit,
  ) {
    emit(MentorDetailsLoading());
    
    // Simulate loading and calculate courses count
    final coursesCount = event.mentor.sessions.length;
    
    emit(MentorDetailsLoaded(
      mentor: event.mentor,
      coursesCount: coursesCount,
    ));
  }

 Future<void> _onLoadMentorCourses(
  LoadMentorCourses event,
  Emitter<MentorDetailsState> emit,
) async {
  final mentor = event.mentor;
  final coursesCount = event.courses.length;

  log(event.courses.toString());

  emit(MentorsCoursesLoadingState(
    mentor: mentor,
    coursesCount: coursesCount,
  ));

  final result = await serviceLocator<GetMentorCoursesUseCase>().call(params: event.courses);

  result.fold(
    (failure) {
      emit(MentorsCoursesErrorState(
        mentor: mentor,
        coursesCount: coursesCount,
      ));
    },
    (courses) {
      emit(MentorsCoursesLoadedState(
        mentor: mentor,
        coursesCount: coursesCount,
        courses: courses,
      ));
    },
  );
}


  void _onChatWithMentor(
    ChatWithMentor event,
    Emitter<MentorDetailsState> emit,
  ) {
    emit(ChatInitiated(event.mentorId));
  }
}

import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class MentorDetailsState {}

class MentorDetailsInitial extends MentorDetailsState {}

class MentorDetailsLoaded extends MentorDetailsState {
  final MentorEntity mentor;
  final int coursesCount;
  
  MentorDetailsLoaded({
    required this.mentor,
    required this.coursesCount,
  });
}

class MentorsCoursesLoadedState extends MentorDetailsLoaded{
  List<CoursePreview> courses;
  MentorsCoursesLoadedState({
    required super.mentor,
    required super.coursesCount,
    required this.courses
    });
}
class MentorsCoursesLoadingState extends MentorDetailsLoaded{
  MentorsCoursesLoadingState({required super.mentor, required super.coursesCount});
}
class MentorsCoursesErrorState extends MentorDetailsLoaded{
  MentorsCoursesErrorState({required super.mentor, required super.coursesCount});
}

class MentorDetailsLoading extends MentorDetailsState {}

class ChatInitiated extends MentorDetailsState {
  final String mentorId;
  ChatInitiated(this.mentorId);
}

// BLoC Events
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class MentorDetailsEvent {}

class LoadMentorDetails extends MentorDetailsEvent {
  final MentorEntity mentor;
  LoadMentorDetails(this.mentor);
}

class LoadMentorCourses extends LoadMentorDetails {
  final List<String> courses;
  LoadMentorCourses(this.courses,super.mentor);
}

class ChatWithMentor extends MentorDetailsEvent {
  final String mentorId;
  ChatWithMentor(this.mentorId);
}
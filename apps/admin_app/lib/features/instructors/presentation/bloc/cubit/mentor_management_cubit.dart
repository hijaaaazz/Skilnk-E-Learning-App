import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/domain/usecases/get_mentors.dart';
import 'package:admin_app/features/instructors/domain/usecases/verify_mentor.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_state.dart';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class MentorManagementCubit extends Cubit<MentorManagementState> {
  MentorManagementCubit() : super(const MentorsLoading(mentors: []));

  void displayMentors() async {
    emit(MentorsLoading(mentors: state.mentors));
    var response = await serviceLocator<GetMentorsUseCase>().call();
    response.fold(
      (error) {
        emit(MentorsLoadingError(mentors: state.mentors));
      },
      (data) {
        emit(MentorsLoadingSucces(mentors: data));
      },
    );
  }

  void updateMentor(MentorEntity updatedMentor,bool toggle) async {
    emit(MentorsUpdationLoading(mentors: state.mentors));

    final response = await serviceLocator<VerifyMentor>().call(params: UpdateParams(tutorId: updatedMentor.tutorId, toggle: toggle));
    response.fold(
      (error) {
        emit(MentorsUpdationError(mentors: state.mentors));
      },
      (data) {
        // Replace updated mentor in the current list
        final updatedList = state.mentors.map((mentor) {
          return mentor.tutorId == updatedMentor.tutorId ? updatedMentor : mentor;
        }).toList();

        emit(MentorsUpdationSuccess(mentors: updatedList));
      },
    );
  }
}

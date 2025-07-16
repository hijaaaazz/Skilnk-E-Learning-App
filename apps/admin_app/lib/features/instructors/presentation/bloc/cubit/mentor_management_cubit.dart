import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/domain/usecases/get_mentors.dart';
import 'package:admin_app/features/instructors/domain/usecases/update_mentor.dart';
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
    final response = await serviceLocator<GetMentorsUseCase>().call();
    response.fold(
      (error) => emit(MentorsLoadingError(mentors: state.mentors)),
      (data) => emit(MentorsLoadingSucces(mentors: data)),
    );
  }

  /// 🔹 Verify or Unverify a Mentor
  Future<void> toggleVerification(String tutorId, bool toggle) async {
    emit(MentorsUpdationLoading(mentors: state.mentors));

    final response = await serviceLocator<VerifyMentor>()
        .call(params: UpdateParams(tutorId: tutorId, toggle: toggle));

    response.fold(
      (error) => emit(MentorsUpdationError(mentors: state.mentors)),
      (_) {
        final updatedList = state.mentors.map((mentor) {
          if (mentor.tutorId == tutorId) {
            return mentor.copyWith(isVerified: toggle);
          }
          return mentor;
        }).toList();

        emit(MentorsUpdationSuccess(mentors: updatedList));
      },
    );
  }

  /// 🔹 Block or Unblock a Mentor
  Future<void> toggleBlock(String tutorId, bool toggle) async {
    emit(MentorsUpdationLoading(mentors: state.mentors));

    final response = await serviceLocator<ToggleBlocMentorUseCase>()
        .call(params: UpdateParams(tutorId: tutorId, toggle: toggle));

    response.fold(
      (error) => emit(MentorsUpdationError(mentors: state.mentors)),
      (_) {
        final updatedList = state.mentors.map((mentor) {
          if (mentor.tutorId == tutorId) {
            return mentor.copyWith(isblocked: toggle);
          }
          return mentor;
        }).toList();

        emit(MentorsUpdationSuccess(mentors: updatedList));
      },
    );
  }
}

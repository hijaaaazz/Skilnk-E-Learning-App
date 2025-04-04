import 'package:admin_app/features/instructors/domain/usecases/get_mentors.dart';
import 'package:admin_app/features/instructors/presentation/bloc/cubit/mentor_management_state.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class MentorManagementCubit extends Cubit<MentorManagementState> {
  MentorManagementCubit() : super(MentorsLoading());

  void displayMentors() async{
    var response = await serviceLocator<GetMentorsUseCase>().call();
    response.fold(
      (error){
        emit(MentorsLoadingError());
      }, 
      (data){
        emit(MentorsLoadingSucces( mentors: data));
      });
  }
}

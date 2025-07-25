import 'package:bloc/bloc.dart';


class LandingNavigationCubit extends Cubit<int> {
  LandingNavigationCubit() : super(3);

  void updateIndex(newIndex) => emit(newIndex);
}

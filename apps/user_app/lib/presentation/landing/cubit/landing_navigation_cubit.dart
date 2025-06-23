import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class LandingNavigationCubit extends Cubit<int> {
  LandingNavigationCubit() : super(3);

  void updateIndex(newIndex) => emit(newIndex);
}

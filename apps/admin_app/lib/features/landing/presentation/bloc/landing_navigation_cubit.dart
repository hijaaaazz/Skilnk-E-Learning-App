import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'landing_navigation_state.dart';

class LandingNavigationCubit extends Cubit<int> {
  LandingNavigationCubit() : super(0);

  void updateIndex(newIndex) => emit(newIndex);
}

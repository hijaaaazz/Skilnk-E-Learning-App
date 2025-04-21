import 'package:bloc/bloc.dart';

class ButtonLoadingCubit extends Cubit<bool> {
  ButtonLoadingCubit() : super(false); // Initial state is false (not loading)

  void startLoading() => emit(true); // Set the state to true when loading starts
  void stopLoading() => emit(false); // Set the state to false when loading stops
}

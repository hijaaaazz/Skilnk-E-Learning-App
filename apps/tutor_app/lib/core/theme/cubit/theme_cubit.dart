import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'theme_state.dart';

enum AppThemeMode{light,dark}

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.light);

  void toggleTheme(){
    emit(state == AppThemeMode.light ?  AppThemeMode.dark : AppThemeMode.light);
  }
}

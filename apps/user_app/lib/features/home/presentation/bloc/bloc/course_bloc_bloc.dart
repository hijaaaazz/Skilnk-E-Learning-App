import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/usecases/get_categories.dart';
import 'package:user_app/features/home/domain/usecases/get_courses.dart';
import 'package:user_app/service_locator.dart';

part 'course_bloc_event.dart';
part 'course_bloc_state.dart';

class CourseBlocBloc extends Bloc<CourseBlocEvent, CourseBlocState> {
  CourseBlocBloc() : super(CourseBlocInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchCourses>(_onFetchCourses);
  }

  Future<void> _onFetchCategories(FetchCategories event, Emitter<CourseBlocState> emit) async {
    emit(CourseBlocLoading());

    final categoriesResult = await serviceLocator<GetCategoriesUseCase>().call(params: NoParams());

    await categoriesResult.fold(
      (failure) async => emit(CourseBlocError(failure)),
      (categories) async {
        final coursesResult = await serviceLocator<GetCoursesUseCase>().call(params: NoParams());
        coursesResult.fold(
          (failure) => emit(CourseBlocError(failure)),
          (courses) => emit(CourseBlocLoaded(categories, courses!)),
        );
      },
    );
  }

  Future<void> _onFetchCourses(FetchCourses event, Emitter<CourseBlocState> emit) async {
    emit(CourseBlocLoading());

    final coursesResult = await serviceLocator<GetCoursesUseCase>().call(params: NoParams());

    coursesResult.fold(
      (failure) => emit(CourseBlocError(failure)),
      (courses) {
        final currentState = state;
        List<CategoryEntity> categories = [];
        if (currentState is CourseBlocLoaded) {
          categories = currentState.categories;
        }
        emit(CourseBlocLoaded(categories, courses!));
      },
    );
  }
}

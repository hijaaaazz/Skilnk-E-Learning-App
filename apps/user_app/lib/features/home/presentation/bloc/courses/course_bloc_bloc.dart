

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/home/data/models/banner_model.dart';
import  'package:user_app/features/home/domain/entity/category_entity.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';
import  'package:user_app/features/home/domain/usecases/get_banner_info.dart';
import  'package:user_app/features/home/domain/usecases/get_categories.dart';
import  'package:user_app/features/home/domain/usecases/get_courses.dart';
import  'package:user_app/features/home/domain/usecases/get_mentors.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_state.dart';
import  'package:user_app/service_locator.dart';

part 'course_bloc_event.dart';


class CourseBlocBloc extends Bloc<CourseBlocEvent, CourseBlocState> {
 

  CourseBlocBloc() : super(CourseBlocInitial()) {
    on<FetchCategories>(_onFetchCategories);
    on<FetchCourses>(_onFetchCourses);
    on<FetchMentors>(_onFetchMentors);
    on<FetchBannerInfo>(_onFetchBannerInfo);

  }

  Future<void> _onFetchCategories(FetchCategories event, Emitter<CourseBlocState> emit) async {
  emit(CourseBlocLoading());

  final categoriesResult = await serviceLocator<GetCategoriesUseCase>().call(params: NoParams());

  categoriesResult.fold(
    (failure) => emit(CourseBlocError(failure)),
    (categories) {
      final currentState = state;
      List<CoursePreview> courses = [];
      List<MentorEntity> mentors = [];
      List<BannerModel> banners = [];

      if (currentState is CourseBlocLoaded) {
        courses = currentState.courses;
        mentors = currentState.mentors;
        banners = currentState.banners;
      }

      emit(CourseBlocLoaded(categories, courses, mentors,banners));
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
      List<MentorEntity> mentors = [];
      List<BannerModel> banners = [];

      if (currentState is CourseBlocLoaded) {
        categories = currentState.categories;
        mentors = currentState.mentors;
        banners = currentState.banners;
      }

      emit(CourseBlocLoaded(categories, courses, mentors,banners));
    },
  );
}

Future<void> _onFetchMentors(FetchMentors event, Emitter<CourseBlocState> emit) async {
  emit(CourseBlocLoading());

  final mentorsResult = await serviceLocator<GetMentorsUseCase>().call(params: NoParams());

  mentorsResult.fold(
    (failure) => emit(CourseBlocError(failure)),
    (mentors) {
      final currentState = state;
      List<CategoryEntity> categories = [];
      List<CoursePreview> courses = [];
      List<BannerModel> banners = [];

      if (currentState is CourseBlocLoaded) {
        categories = currentState.categories;
        courses = currentState.courses;
        banners = currentState.banners;
      }

      emit(CourseBlocLoaded(categories, courses, mentors,banners));
    },
  );
}

Future<void> _onFetchBannerInfo(FetchBannerInfo event, Emitter<CourseBlocState> emit) async {
  emit(CourseBlocLoading());

  final bannerResult = await serviceLocator<GetBannerInfoUseCase>().call(params: NoParams());
  log("bannerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr ${bannerResult.toString()}");
  bannerResult.fold(
    (failure) => emit(CourseBlocError(failure)),
    (banners) {
      final currentState = state;
      List<CategoryEntity> categories = [];
      List<CoursePreview> courses = [];
      List<MentorEntity> mentors= [];

      if (currentState is CourseBlocLoaded) {
        categories = currentState.categories;
        courses = currentState.courses;
        mentors = currentState.mentors;
      }

      log("bannerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr ${banners.toString()}");

      emit(CourseBlocLoaded(categories, courses, mentors,banners));
    },
  );
}

 

}

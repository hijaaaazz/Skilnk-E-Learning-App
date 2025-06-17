// lib/features/explore/presentation/bloc/explore_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/domain/entities.dart/search-results.dart';
import 'package:user_app/features/explore/domain/usecases/get_search_results.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/service_locator.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetSearchResultsUseCase _getSearchResultsUseCase = serviceLocator<GetSearchResultsUseCase>();
  
  ExploreBloc() : super(ExploreState.initial()) {
    on<InitializeExplore>(_onInitializeExplore);
    on<SearchExplore>(_onSearchExplore);
    on<SelectMainChip>(_onSelectMainChip);
    on<SelectCategory>(_onSelectCategory);
    on<ClearCategory>(_onClearCategory);
    on<ApplyFilter>(_onApplyFilter);
    on<ApplySorting>(_onApplySorting);
    on<FetchCourses>(_onFetchCourses);
    on<FetchMentors>(_onFetchMentors);
    on<FetchCategories>(_onFetchCategories);
    on<ClearSorting>(_onClearSorting);
  }

  void _onInitializeExplore(InitializeExplore event, Emitter<ExploreState> emit) async {
  final selectedType = event.params?.type ?? SearchType.course;

  emit(state.copyWith(
    isLoading: true,
    selectedMainChip: selectedType,
  ));

  try {
    // Variables to hold results
    List<CoursePreview>? courses;
    List<MentorEntity>? mentors;
    List<CategoryEntity>? categories;

    final result = await _getSearchResultsUseCase(
      params: event.params ??
          SearchParams(
            query: '',
            type: selectedType,
            filter: FilterOption.all,
          ),
    );

    // Use fold pattern
    result.fold(
      (error) => throw Exception(error),
      (res) {
        if (res is CourseResult) {
          courses = res.courses;
        } else if (res is MentorResult) {
          mentors = res.mentors;
        } else if (res is CategoryResult) {
          categories = res.categories;
        } else {
          throw Exception('Unexpected result type');
        }
      },
    );

    emit(state.copyWith(
      allCourses: courses ?? state.allCourses,
      filteredCourses: courses ?? state.filteredCourses,
      allMentors: mentors ?? state.allMentors,
      filteredMentors: mentors ?? state.filteredMentors,
      allCategories: categories ?? state.allCategories,
      filteredCategories: categories ?? state.filteredCategories,
      isLoading: false,
    ));
  } catch (e) {
    emit(state.copyWith(
      errorMessage: 'Failed to initialize: ${e.toString()}',
      isLoading: false,
    ));
  }
}


  void _onSearchExplore(SearchExplore event, Emitter<ExploreState> emit) async {
    final query = event.query.toLowerCase();
  
  // Update the appropriate query based on selected main chip
  switch (state.selectedMainChip) {
    case SearchType.course:
      emit(state.copyWith(coursesQuery: query, isLoading: true));
      break;
    case SearchType.mentor:
      emit(state.copyWith(mentorsQuery: query, isLoading: true));
      break;
    case SearchType.category:
      emit(state.copyWith(categoriesQuery: query, isLoading: true));
      break;
  }

    try {
      switch (state.selectedMainChip) {
        case SearchType.course:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: query,
            type: SearchType.course,
            filter: state.selectedFilter,
            category: state.selectedCategory?.id,
            sort: state.selectedSortArgs,
            sortOption: state.selectedSortOption,
          ));
          final courses = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CourseResult).courses,
          );
          
          emit(state.copyWith(
            filteredCourses: courses,
            isLoading: false,
          ));
          break;

        case SearchType.mentor:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: query,
            type: SearchType.mentor,
            filter: state.selectedFilter,
          ));
          final mentors = result.fold(
            (error) => throw Exception(error),
            (result) => (result as MentorResult).mentors,
          );
          emit(state.copyWith(
            filteredMentors: mentors,
            isLoading: false,
          ));
          break;

        case SearchType.category:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: query,
            type: SearchType.category,
            filter: state.selectedFilter,
          ));
          final categories = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CategoryResult).categories,
          );
          emit(state.copyWith(
            filteredCategories: categories,
            isLoading: false,
          ));
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error searching: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

 void _onSelectMainChip(SelectMainChip event, Emitter<ExploreState> emit) async {
  // Only process if we're actually changing tabs
  if (event.chipName == state.selectedMainChip) {
    return;
  }

  String currentQuery = '';
  
  // Determine the current query for the selected chip
  switch (event.chipName) {
    case SearchType.course:
      currentQuery = state.coursesQuery;
      break;
    case SearchType.mentor:
      currentQuery = state.mentorsQuery;
      break;
    case SearchType.category:
      currentQuery = state.categoriesQuery;
      break;
  }

  // First emit just the chip change without loading state
  // This prevents flickering while maintaining visual feedback
  emit(state.copyWith(
    selectedMainChip: event.chipName,
    searchQuery: currentQuery,
    isLoading: false, // Keep as false to avoid unnecessary flicker
  ));

  // Check if we already have data for this tab
  bool shouldFetchData = false;
  switch (event.chipName) {
    case SearchType.course:
      shouldFetchData = state.filteredCourses.isEmpty;
      break;
    case SearchType.mentor:
      shouldFetchData = state.filteredMentors.isEmpty;
      break;
    case SearchType.category:
      shouldFetchData = state.filteredCategories.isEmpty;
      break;
  }

  // Only fetch if we need to
  if (shouldFetchData) {
    // Now set loading state
    emit(state.copyWith(isLoading: true));
    
    try {
      switch (event.chipName) {
        case SearchType.course:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: currentQuery,
            type: SearchType.course,
            filter: state.selectedFilter,
            category: state.selectedCategory?.id,
            sort: state.selectedSortArgs,
            sortOption: state.selectedSortOption,
          ));
          final courses = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CourseResult).courses,
          );
          emit(state.copyWith(filteredCourses: courses, isLoading: false));
          break;

        case SearchType.mentor:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: currentQuery,
            type: SearchType.mentor,
            filter: state.selectedFilter,
          ));
          final mentors = result.fold(
            (error) => throw Exception(error),
            (result) => (result as MentorResult).mentors,
          );
          emit(state.copyWith(filteredMentors: mentors, isLoading: false));
          break;

        case SearchType.category:
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: currentQuery,
            type: SearchType.category,
            filter: state.selectedFilter,
          ));
          final categories = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CategoryResult).categories,
          );
          emit(state.copyWith(filteredCategories: categories, isLoading: false));
          break;
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error switching tab: ${e.toString()}',
        isLoading: false,
      ));
    }
  }
}


  void _onSelectCategory(SelectCategory event, Emitter<ExploreState> emit) async {
    
    emit(state.copyWith(isLoading: true));
    
    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.coursesQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
        category: event.categoryId.id,
        sort: state.selectedSortArgs,
        sortOption: state.selectedSortOption,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      emit(state.copyWith(
        selectedCategory: event.categoryId,
        selectedMainChip: SearchType.course,

        filteredCourses: courses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error selecting category: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onClearCategory(ClearCategory event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.coursesQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
        sort: state.selectedSortArgs,
        sortOption: state.selectedSortOption,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      emit(state.copyWith(
        clearSelectedCategory: true,  // This will set selectedCategory to null
        filteredCourses: courses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error clearing category: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onApplyFilter(ApplyFilter event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.course,
        filter: event.filter,
        category: state.selectedCategory?.id,
        sort: state.selectedSortArgs,
        sortOption: state.selectedSortOption,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      emit(state.copyWith(
        selectedFilter: event.filter,
        filteredCourses: courses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error applying filter: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onApplySorting(ApplySorting event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      // Request sorted results from backend
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
        category: state.selectedCategory?.id,
        sort: event.sortArgs,
        sortOption: event.sortOption,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      emit(state.copyWith(
        selectedSortOption: event.sortOption,
        selectedSortArgs: event.sortArgs,
        filteredCourses: courses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error applying sorting: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onFetchCourses(FetchCourses event, Emitter<ExploreState> emit) async {
    if (event.refresh) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
        category: state.selectedCategory?.id,
        sort: state.selectedSortArgs,
        sortOption: state.selectedSortOption,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      emit(state.copyWith(
        allCourses: courses,
        filteredCourses: courses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error fetching courses: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onFetchMentors(FetchMentors event, Emitter<ExploreState> emit) async {
    if (event.refresh) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.mentor,
        filter: state.selectedFilter,
      ));
      final mentors = result.fold(
        (error) => throw Exception(error),
        (result) => (result as MentorResult).mentors,
      );

      emit(state.copyWith(
        allMentors: mentors,
        filteredMentors: mentors,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error fetching mentors: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onFetchCategories(FetchCategories event, Emitter<ExploreState> emit) async {
    if (event.refresh) {
      emit(state.copyWith(isLoading: true));
    }

    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.category,
        filter: state.selectedFilter,
      ));
      final categories = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CategoryResult).categories,
      );

      emit(state.copyWith(
        allCategories: categories,
        filteredCategories: categories,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error fetching categories: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

 void _onClearSorting(ClearSorting event, Emitter<ExploreState> emit) async {
  emit(state.copyWith(isLoading: true));
  
  try {
    // Request results from backend without sorting parameters
    final result = await _getSearchResultsUseCase(params: SearchParams(
      query: state.searchQuery,
      type: SearchType.course,
      filter: state.selectedFilter,
      category: state.selectedCategory?.id,
      // No sort parameters here
    ));
    
    final courses = result.fold(
      (error) => throw Exception(error),
      (result) => (result as CourseResult).courses,
    );
    
    // Make sure to explicitly set these to null
    emit(state.copyWith(
      selectedSortOption: null,
      selectedSortArgs: null,
      filteredCourses: courses,
      isLoading: false,
    ));
  } catch (e) {
    emit(state.copyWith(
      errorMessage: 'Error clearing sorting: ${e.toString()}',
      isLoading: false,
    ));
  }

}
}
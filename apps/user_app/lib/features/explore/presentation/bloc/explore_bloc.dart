// lib/features/explore/presentation/bloc/explore_bloc.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/domain/entities.dart/search-results.dart';
import 'package:user_app/features/explore/domain/usecases/get_search_results.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
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
  }

  void _onInitializeExplore(InitializeExplore event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Fetch courses
      final courseResult = await _getSearchResultsUseCase(params: SearchParams(
        query: '',
        type: SearchType.course,
        filter: FilterOption.all,
      ));
      final courses = courseResult.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );

      // Fetch mentors
      final mentorResult = await _getSearchResultsUseCase(params: SearchParams(
        query: '',
        type: SearchType.mentor,
        filter: FilterOption.all,
      ));
      final mentors = mentorResult.fold(
        (error) => throw Exception(error),
        (result) => (result as MentorResult).mentors,
      );

      // Fetch categories
      final categoryResult = await _getSearchResultsUseCase(params: SearchParams(
        query: '',
        type: SearchType.category,
        filter: FilterOption.all,
      ));
      final categories = categoryResult.fold(
        (error) => throw Exception(error),
        (result) => (result as CategoryResult).categories,
      );

      emit(state.copyWith(
        allCourses: courses,
        filteredCourses: courses,
        allMentors: mentors,
        filteredMentors: mentors,
        allCategories: categories,
        filteredCategories: categories,
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
    emit(state.copyWith(searchQuery: query, isLoading: true));

    try {
      switch (state.selectedMainChip) {
        case 'Courses':
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: query,
            type: SearchType.course,
            filter: state.selectedFilter,
            category: state.selectedCategoryId,
          ));
          final courses = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CourseResult).courses,
          );
          
          // Apply sorting after fetching
          final sortedCourses = _applySortingToList(
            courses,
            state.selectedSortArgs,
            state.selectedSortOption,
          );
          
          emit(state.copyWith(
            filteredCourses: sortedCourses,
            isLoading: false,
          ));
          break;

        case 'Mentors':
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

        case 'Categories':
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
    emit(state.copyWith(
      selectedMainChip: event.chipName,
      searchQuery: '',
      isLoading: true,
    ));

    try {
      switch (event.chipName) {
        case 'Courses':
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: '',
            type: SearchType.course,
            filter: state.selectedFilter,
            category: state.selectedCategoryId,
          ));
          final courses = result.fold(
            (error) => throw Exception(error),
            (result) => (result as CourseResult).courses,
          );
          
          // Apply sorting after fetching
          final sortedCourses = _applySortingToList(
            courses,
            state.selectedSortArgs,
            state.selectedSortOption,
          );
          
          emit(state.copyWith(
            filteredCourses: sortedCourses,
            isLoading: false,
          ));
          break;

        case 'Mentors':
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: '',
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

        case 'Categories':
          final result = await _getSearchResultsUseCase(params: SearchParams(
            query: '',
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
        errorMessage: 'Error switching tab: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onSelectCategory(SelectCategory event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final result = await _getSearchResultsUseCase(params: SearchParams(
        query: state.searchQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
        category: event.categoryId,
      ));
      
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );
      
      // Apply sorting after fetching
      final sortedCourses = _applySortingToList(
        courses,
        state.selectedSortArgs,
        state.selectedSortOption,
      );

      emit(state.copyWith(
        selectedCategoryId: event.categoryId,
        selectedMainChip: 'Courses',
        filteredCourses: sortedCourses,
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
        query: state.searchQuery,
        type: SearchType.course,
        filter: state.selectedFilter,
      ));
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );
      
      // Apply sorting after fetching
      final sortedCourses = _applySortingToList(
        courses,
        state.selectedSortArgs,
        state.selectedSortOption,
      );

      emit(state.copyWith(
        selectedCategoryId: null,
        filteredCourses: sortedCourses,
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
        category: state.selectedCategoryId,
      ));
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );
      
      // Apply sorting after fetching
      final sortedCourses = _applySortingToList(
        courses,
        state.selectedSortArgs,
        state.selectedSortOption,
      );

      emit(state.copyWith(
        selectedFilter: event.filter,
        filteredCourses: sortedCourses,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error applying filter: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  void _onApplySorting(ApplySorting event, Emitter<ExploreState> emit) {
    emit(state.copyWith(isLoading: true));
    
    try {
      // Apply sorting to the existing filteredCourses list
      final sortedCourses = _applySortingToList(
        state.filteredCourses,
        event.sortArgs,
        event.sortOption,
      );

      emit(state.copyWith(
        selectedSortOption: event.sortOption,
        selectedSortArgs: event.sortArgs,
        filteredCourses: sortedCourses,
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
        category: state.selectedCategoryId,
      ));
      final courses = result.fold(
        (error) => throw Exception(error),
        (result) => (result as CourseResult).courses,
      );
      
      // Apply sorting after fetching
      final sortedCourses = _applySortingToList(
        courses,
        state.selectedSortArgs,
        state.selectedSortOption,
      );

      emit(state.copyWith(
        allCourses: courses,
        filteredCourses: sortedCourses,
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

  // Helper method to apply sorting to a list of courses
  List<CoursePreview> _applySortingToList(
    List<CoursePreview> courses,
    SortArgs? sortArgs,
    SortOption? sortOption
  ) {
    if (sortArgs == null || sortOption == null) {
      return courses;
    }
    
    // Create a copy of the list to avoid modifying the original
    final List<CoursePreview> result = List.from(courses);
    
    switch (sortArgs) {
      case SortArgs.price:
        if (sortOption == SortOption.ascending) {
          result.sort((a, b) {
            double priceA = _parsePrice(a.price);
            double priceB = _parsePrice(b.price);
            return priceA.compareTo(priceB);
          });
        } else {
          result.sort((a, b) {
            double priceA = _parsePrice(a.price);
            double priceB = _parsePrice(b.price);
            return priceB.compareTo(priceA);
          });
        }
        break;
      case SortArgs.rating:
        if (sortOption == SortOption.ascending) {
          result.sort((a, b) => a.averageRating.compareTo(b.averageRating));
        } else {
          result.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        }
        break;
    }
    
    return result;
  }

  // Helper method to parse price string to double
  double _parsePrice(String price) {
    if (price.toLowerCase() == 'free') return 0.0;
    
    // Remove currency symbol and parse as double
    final numericString = price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }
}
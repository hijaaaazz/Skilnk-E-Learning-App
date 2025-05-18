// explore_state.dart
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class ExploreState {
  final List<String> mainChips;
  final String selectedMainChip;
  final List<CategoryEntity> allCategories;
  final List<CategoryEntity> filteredCategories;
  final String? selectedCategoryId;
  final FilterOption selectedFilter;
  final SortArgs? selectedSortArgs;
  final SortOption? selectedSortOption;
  final List<CoursePreview> allCourses;
  final List<CoursePreview> filteredCourses;
  final List<MentorEntity> allMentors;
  final List<MentorEntity> filteredMentors;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;
  
  ExploreState({
    required this.mainChips,
    required this.selectedMainChip,
    required this.allCategories,
    required this.filteredCategories,
    this.selectedCategoryId,
    required this.selectedFilter,
    this.selectedSortArgs,
    this.selectedSortOption,
    required this.allCourses,
    required this.filteredCourses,
    required this.allMentors,
    required this.filteredMentors,
    required this.searchQuery,
    required this.isLoading,
    this.errorMessage,
  });
  
  factory ExploreState.initial() {
  return ExploreState(
    mainChips: ['Courses', 'Mentors', 'Categories'],
    selectedMainChip: 'Courses',
    allCategories: [],
    filteredCategories: [],
    selectedCategoryId: null,
    selectedFilter: FilterOption.all,
    selectedSortArgs: null,
    selectedSortOption: null,
    allCourses: [],
    filteredCourses: [],
    allMentors: [],
    filteredMentors: [],
    searchQuery: '',
    isLoading: false,
    errorMessage: null,
  );
}
  
  ExploreState copyWith({
    List<String>? mainChips,
    String? selectedMainChip,
    List<CategoryEntity>? allCategories,
    List<CategoryEntity>? filteredCategories,
    String? selectedCategoryId,
    FilterOption? selectedFilter,
    SortArgs? selectedSortArgs,
    SortOption? selectedSortOption,
    List<CoursePreview>? allCourses,
    List<CoursePreview>? filteredCourses,
    List<MentorEntity>? allMentors,
    List<MentorEntity>? filteredMentors,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExploreState(
      mainChips: mainChips ?? this.mainChips,
      selectedMainChip: selectedMainChip ?? this.selectedMainChip,
      allCategories: allCategories ?? this.allCategories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSortArgs: selectedSortArgs ?? this.selectedSortArgs,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      allCourses: allCourses ?? this.allCourses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      allMentors: allMentors ?? this.allMentors,
      filteredMentors: filteredMentors ?? this.filteredMentors,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

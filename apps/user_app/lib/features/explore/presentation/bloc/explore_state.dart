import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class ExploreState {
  final List<SearchType> mainChips;
  final SearchType selectedMainChip;
  final List<CategoryEntity> allCategories;
  final List<CategoryEntity> filteredCategories;
  final CategoryEntity? selectedCategory;
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
  final String coursesQuery;
  final String mentorsQuery;
  final String categoriesQuery;
  
  ExploreState({
    required this.mainChips,
    required this.selectedMainChip,
    required this.allCategories,
    required this.filteredCategories,
    this.selectedCategory,
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
    this.coursesQuery = '',
    this.mentorsQuery = '',
    this.categoriesQuery = '',
  });

  factory ExploreState.initial() {
    return ExploreState(
      mainChips: [SearchType.course,SearchType.category,SearchType.mentor] ,
      selectedMainChip: SearchType.course,
      allCategories: [],
      filteredCategories: [],
      selectedCategory: null,
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
    List<SearchType>? mainChips,
    SearchType? selectedMainChip,
    List<CategoryEntity>? allCategories,
    List<CategoryEntity>? filteredCategories,
    CategoryEntity? selectedCategory,
    bool clearSelectedCategory = false,
    FilterOption? selectedFilter,
    Object? selectedSortArgs = const Object(),
    Object? selectedSortOption = const Object(),
    List<CoursePreview>? allCourses,
    List<CoursePreview>? filteredCourses,
    List<MentorEntity>? allMentors,
    List<MentorEntity>? filteredMentors,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    String? coursesQuery,
    String? mentorsQuery,
    String? categoriesQuery,
  }) {
    return ExploreState(
      mainChips: mainChips ?? this.mainChips,
      selectedMainChip: selectedMainChip ?? this.selectedMainChip,
      allCategories: allCategories ?? this.allCategories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedSortArgs: selectedSortArgs == const Object() ? this.selectedSortArgs : selectedSortArgs as SortArgs?,
      selectedSortOption: selectedSortOption == const Object() ? this.selectedSortOption : selectedSortOption as SortOption?,
      allCourses: allCourses ?? this.allCourses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      allMentors: allMentors ?? this.allMentors,
      filteredMentors: filteredMentors ?? this.filteredMentors,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      coursesQuery: coursesQuery ?? this.coursesQuery,
      mentorsQuery: mentorsQuery ?? this.mentorsQuery,
      categoriesQuery: categoriesQuery ?? this.categoriesQuery,
    );
  }
}
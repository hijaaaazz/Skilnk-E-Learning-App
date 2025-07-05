import  'package:user_app/features/explore/data/models/search_args.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/home/domain/entity/category_entity.dart';

abstract class ExploreEvent {}

class InitializeExplore extends ExploreEvent {
  final SearchParams? params;

  InitializeExplore({this.params}); 
}

class SearchExplore extends ExploreEvent {
  final String query;
  
  SearchExplore(this.query);
}

class SelectMainChip extends ExploreEvent {
  final SearchType chipName;
  
  SelectMainChip(this.chipName);
}

class SelectCategory extends ExploreEvent {
  final CategoryEntity categoryId;
  
  SelectCategory(this.categoryId);
}

class ClearCategory extends ExploreEvent {}

class ApplyFilter extends ExploreEvent {
  final FilterOption filter;
  
  ApplyFilter(this.filter);
}

class ApplySorting extends ExploreEvent {
  final SortOption sortOption;
  final SortArgs sortArgs;
  
  ApplySorting(this.sortOption,this.sortArgs);
}

class FetchCourses extends ExploreEvent {
  final bool refresh;
  
  FetchCourses({this.refresh = false});
}

class FetchMentors extends ExploreEvent {
  final bool refresh;
  
  FetchMentors({this.refresh = false});
}

class FetchCategories extends ExploreEvent {
  final bool refresh;
  
  FetchCategories({this.refresh = false});
}



class ClearSorting extends ExploreEvent {
  
  ClearSorting();
}

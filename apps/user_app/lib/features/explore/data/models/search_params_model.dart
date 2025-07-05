// lib/features/explore/data/models/search_params_model.dart
import  'package:user_app/features/explore/data/models/search_args.dart';

class SearchParams {
  final String query;
  final SearchType type;
  final FilterOption? filter;
  final String? category;
  final SortArgs? sort;
  final SortOption? sortOption;

  SearchParams({
    required this.query,
    required this.type,
    this.filter,
    this.category,
    this.sort,
    this.sortOption,
  });
}
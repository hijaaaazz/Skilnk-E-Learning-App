import 'package:user_app/features/explore/data/models/search_args.dart';

class SearchParams {
  final String query;
  final String? category;
  final SearchType type;
  final FilterOption? filter;
  final SortOption? sort;
  final SortArgs? sortArgs;

  SearchParams({
    required this.query,
    required this.type,
    this.category,
    this.sortArgs,
    this.filter,
    this.sort,
  });
}

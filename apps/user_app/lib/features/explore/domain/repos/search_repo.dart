import 'package:dartz/dartz.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/explore/domain/entities.dart/search-results.dart';

abstract class SearchAndFilterRepository {
  Future<Either<String,SearchResult>> getSearchResults(SearchParams params);
}
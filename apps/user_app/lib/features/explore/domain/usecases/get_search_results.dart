

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/domain/entities.dart/search-results.dart';
import 'package:user_app/features/explore/domain/repos/search_repo.dart';
import 'package:user_app/service_locator.dart';

class GetSearchResultsUseCase implements Usecase<Either<String, SearchResult>, SearchParams> {
  @override
  Future<Either<String, SearchResult>> call({required SearchParams params}) {
    log('search and filter started');
    return  serviceLocator<SearchAndFilterRepository>().getSearchResults(params);
  }
}
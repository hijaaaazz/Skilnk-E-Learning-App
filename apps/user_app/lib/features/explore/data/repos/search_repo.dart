import 'dart:developer';

import 'package:dartz/dartz.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/explore/data/src/firebase_services.dart';
import  'package:user_app/features/explore/domain/entities.dart/search-results.dart';
import  'package:user_app/features/explore/domain/repos/search_repo.dart';
import  'package:user_app/service_locator.dart';

class SearchAndFilterRepositoryImp extends SearchAndFilterRepository{
  @override
  Future<Either<String, SearchResult>> getSearchResults(SearchParams params)async {
    try {
      final results = await serviceLocator<ExploreFirebaseService>().getSearchResults(params);
      
      return results.fold(
        (error) => Left(error),
        (result) async {
         
          return Right(result);
        }
      );
    } catch (e, stacktrace) {
      log('get serach results unexpected error: $e\n$stacktrace');
      return Left('Failed to check isEmailVerified');
    }
  }

}
// lib/features/explore/data/datasources/explore_firebase_service.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/explore/domain/entities.dart/search-results.dart';
import 'package:user_app/features/home/data/models/category_model.dart';
import 'package:user_app/features/home/data/models/mentor_mode.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';

abstract class ExploreFirebaseService {
  Future<Either<String, SearchResult>> getSearchResults(SearchParams params);
}

class ExploreFirebaseServicesImp extends ExploreFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, SearchResult>> getSearchResults(SearchParams params) async {
    log('[START] Search initiated');
    log('[INPUT] query=${params.query}, type=${params.type}, filter=${params.filter}, sort=${params.sort}, sortOption=${params.sortOption}, category=${params.category}');
    
    try {
      late SearchResult results;

      switch (params.type) {
        case SearchType.mentor:
          log('[MENTOR] Building query');
          final snapshot = await _firestore
              .collection('mentors')
              .orderBy('name_lower')
              .startAt([params.query])
              .endAt(['${params.query}\uf8ff'])
              .get();
          log('[MENTOR] Docs found: ${snapshot.docs.length}');
          
          final mentors = snapshot.docs
              .map((doc) => MentorModel.fromJson(doc.data()).toEntity())
              .toList();
          log('[MENTOR] Parsed mentors: ${mentors.map((m) => m.name).toList()}');

          results = MentorResult(mentors);
          break;

        case SearchType.course:
          log('[COURSE] Building query');
          Query<Map<String, dynamic>> query = _firestore.collection('courses');

          // Apply query only if search query is present
          final hasQuery = params.query.trim().isNotEmpty;

          if (hasQuery) {
            query = query
              .orderBy('title_lower')
              .startAt([params.query.toLowerCase()])
              .endAt(['${params.query.toLowerCase()}\uf8ff']);
          }

          // Category filter
          if (params.category != null && params.category!.isNotEmpty) {
            log('[COURSE] Adding category filter: ${params.category}');
            query = query.where('category', isEqualTo: params.category);
          }

          // Filter logic
          switch (params.filter) {
            case FilterOption.free:
              log('[COURSE] Applying filter: FREE');
              query = query.where('price', isEqualTo: 0);
              break;

            case FilterOption.paid:
              log('[COURSE] Applying filter: PAID');
              query = query.where('price', isGreaterThan: 0);
              break;

            case FilterOption.popular:
              log('[COURSE] Applying filter: POPULAR');
              if (!hasQuery) query = query.orderBy('enrolled_count', descending: true);
              break;

            case FilterOption.recent:
              log('[COURSE] Applying filter: RECENT');
              if (!hasQuery) query = query.orderBy('createdAt', descending: true);
              break;

            case FilterOption.topRated:
              log('[COURSE] Applying filter: TOP RATED');
              if (!hasQuery) query = query.orderBy('average_rating', descending: true);
              break;

            case FilterOption.all:
            case null:
              log('[COURSE] No specific filter applied');
              // No filter to apply
              break;
          }

          // Apply sorting if no specific filter or query is affecting the order
          if (!hasQuery && (params.filter == FilterOption.all || params.filter == null)) {
            if (params.sort != null && params.sortOption != null) {
              log('[COURSE] Applying sort: ${params.sort} in ${params.sortOption} order');
              
              String fieldName;
              bool descending;
              
              switch (params.sort) {
                case SortArgs.price:
                  fieldName = 'price';
                  descending = params.sortOption == SortOption.descending;
                  break;
                case SortArgs.rating:
                  fieldName = 'average_rating';
                  descending = params.sortOption == SortOption.descending;
                  break;
                default:
                  fieldName = 'title_lower';
                  descending = false;
              }
              
              query = query.orderBy(fieldName, descending: descending);
            } else {
              // Default sort if no sort specified
              if (params.category == null) {
                log('[COURSE] Using default sort (by title ascending)');
                query = query.orderBy('title_lower');
              }

            }
          }

          final snapshot = await query.get();
          log('[COURSE] Docs found: ${snapshot.docs.length}');

          final courses = snapshot.docs.map((doc) {
            final data = doc.data();
            return CoursePreview(
              isComplted: data['isCompleted']?? false,
              id: doc.id,
              thumbnail: data['course_thumbnail'],
              courseTitle: data['title'],
              averageRating: data['average_rating'].toDouble(),
              categoryname: data['category_name'],
              price: data['price'].toString(),
            );
          }).toList();

          // If the query or filter affected ordering and sort is specified, do client-side sorting
          if ((hasQuery || (params.filter != FilterOption.all && params.filter != null)) && 
              params.sort != null && params.sortOption != null) {
            log('[COURSE] Applying client-side sort for filtered results');
            _applySortingToList(courses, params.sort!, params.sortOption!);
          }

          log('[COURSE] Parsed courses: ${courses.map((c) => c.courseTitle).toList()}');
          results = CourseResult(courses);
          break;

        case SearchType.category:
          log('[CATEGORY] Building query');
          final snapshot = await _firestore
              .collection('categories')
              .orderBy('title_lower')
              .startAt([params.query])
              .endAt(['${params.query}\uf8ff'])
              .get();
          log('[CATEGORY] Docs found: ${snapshot.docs.length}');

          final categories = snapshot.docs
    .map((doc) => CategoryModel.fromJson(doc.data()).toEntity())
    .where((category) => category.courses.isNotEmpty)
    .toList();

          log('[CATEGORY] Parsed categories: ${categories.map((c) => c.id).toList()}');

          results = CategoryResult(categories);
          break;
      }

      log('[SUCCESS] Search completed');
      return Right(results);
    } catch (e, stack) {
      log('[ERROR] Search failed: $e', stackTrace: stack);
      return Left('Failed to fetch search results');
    }
  }

  // Helper method for client-side sorting when necessary
  void _applySortingToList(
    List<CoursePreview> courses,
    SortArgs sortArgs,
    SortOption sortOption
  ) {
    switch (sortArgs) {
      case SortArgs.price:
        if (sortOption == SortOption.ascending) {
          courses.sort((a, b) {
            double priceA = _parsePrice(a.price);
            double priceB = _parsePrice(b.price);
            return priceA.compareTo(priceB);
          });
        } else {
          courses.sort((a, b) {
            double priceA = _parsePrice(a.price);
            double priceB = _parsePrice(b.price);
            return priceB.compareTo(priceA);
          });
        }
        break;
      case SortArgs.rating:
        if (sortOption == SortOption.ascending) {
          courses.sort((a, b) => a.averageRating.compareTo(b.averageRating));
        } else {
          courses.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        }
        break;
    }
  }

  // Helper method to parse price string to double
  double _parsePrice(String price) {
    if (price.toLowerCase() == 'free') return 0.0;
    
    // Remove currency symbol and parse as double
    final numericString = price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }
}
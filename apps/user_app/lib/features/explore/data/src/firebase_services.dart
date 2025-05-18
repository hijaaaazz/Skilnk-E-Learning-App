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
  log('[INPUT] query=${params.query}, type=${params.type}, filter=${params.filter}, sort=${params.sort}, category=${params.category}');
  
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



        final snapshot = await query.get();
        log('[COURSE] Docs found: ${snapshot.docs.length}');

        final courses = snapshot.docs.map((doc) {
          final data = doc.data();
          return CoursePreview(
            id: doc.id,
            thumbnail: data['course_thumbnail'],
            courseTitle: data['title'],
            averageRating: data['average_rating'].toDouble(),
            categoryname: data['category_name'],
            price: data['price'].toString(),
          );
        }).toList();

        log('[COURSE] Parsed courses: ${courses.map((c) => c.courseTitle).toList()}');
        results = CourseResult(courses);
        break;

      case SearchType.category:
        log('[CATEGORY] Building query');
        final snapshot = await _firestore
            .collection('categories')
            .orderBy('title')
            .startAt([params.query])
            .endAt(['${params.query}\uf8ff'])
            .get();
        log('[CATEGORY] Docs found: ${snapshot.docs.length}');

        final categories = snapshot.docs
            .map((doc) => CategoryModel.fromJson(doc.data()).toEntity())
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

}

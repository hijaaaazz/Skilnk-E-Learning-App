import 'package:meta/meta.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
sealed class CourseListState {}

final class CourseListInitial extends CourseListState {}

final class CourseListLoading extends CourseListState {}

final class CourseListLoaded extends CourseListState {
  final List<CoursePreview> courses;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;

  CourseListLoaded({
    required this.courses,
    required this.hasReachedMax,
    this.lastDocument,
  });
}

final class CourseListLoadingMore extends CourseListState {
  final List<CoursePreview> courses;
  final DocumentSnapshot? lastDocument;

  CourseListLoadingMore({
    required this.courses,
    this.lastDocument,
  });
}

final class CourseListError extends CourseListState {
  final String message;

  CourseListError({required this.message});
}
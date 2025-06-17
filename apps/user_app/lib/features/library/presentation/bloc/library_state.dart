
// library_state.dart
part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

final class LibraryInitial extends LibraryState {}

final class LibraryLoading extends LibraryState {}

final class LibraryLoaded extends LibraryState {
  final List<CoursePreview> savedCourses;
  final List<CoursePreview> enrolledCourses;
  final List<String> savedIds;
  final List<String> enrolledIds;

  LibraryLoaded({
    required this.savedCourses,
    required this.enrolledCourses,
    required this.enrolledIds,
    required this.savedIds
  });
}

final class LibraryError extends LibraryState {
  final String message;

  LibraryError({required this.message});
}
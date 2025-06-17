import 'package:meta/meta.dart';

@immutable
sealed class CourseListEvent {}

final class LoadList extends CourseListEvent {
  final List<String> courseIds;

  LoadList({required this.courseIds});
}

final class FetchPage extends CourseListEvent {
  final List<String> courseIds;
  final int pageKey;

  FetchPage({required this.courseIds, required this.pageKey});
}
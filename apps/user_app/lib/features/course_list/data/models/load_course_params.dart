
// Updated LoadCourseParams model
import 'package:cloud_firestore/cloud_firestore.dart';

class LoadCourseParams {
  final List<String> courseIds;
  final DocumentSnapshot? lastDoc;
  final int pageSize;
  
  LoadCourseParams({
    required this.courseIds,
    this.lastDoc,
    this.pageSize = 5,
  });
}
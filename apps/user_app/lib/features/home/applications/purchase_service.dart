import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';

class PurchaseService {
  Future<void> handlePurchase({
    required BuildContext context,
    required CourseEntity course,
    required void Function(CourseDetailsLoadedState) emit,
  }) async {
    emit(CoursePurchaseProcessing(coursedetails: course));

    // Simulate purchase logic or actual use case
    await Future.delayed(Duration(milliseconds: 500)); // Simulated delay

    emit(CoursePurchaseSuccess(coursedetails: course));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${course.title} purchased successfully')),
    );
  }
}

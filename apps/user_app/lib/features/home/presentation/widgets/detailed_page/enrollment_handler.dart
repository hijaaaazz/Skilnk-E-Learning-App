import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import  'package:user_app/features/payment/presentation/bloc/bloc/enroll_bloc.dart';
import  'package:user_app/features/payment/presentation/bloc/bloc/enroll_state.dart';
import  'package:user_app/features/payment/presentation/widgets/payment_bottom_sheet.dart';

class EnrollmentHandler {
  static void handleAction(BuildContext context, CourseEntity course, VoidCallback onNavigate) {
    final userId = context.read<AuthStatusCubit>().state.user?.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to enroll'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (course.isEnrolled) {
      onNavigate();
    } else {
      _showEnrollmentBottomSheet(context, course, userId);
    }
  }

  static void _showEnrollmentBottomSheet(BuildContext context, CourseEntity course, String userId) {
    try {
      final courseCubit = context.read<CourseCubit>();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetContext) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => EnrollmentBloc(
                onPurchaseSuccess: (enrolledCourse) {
                  try {
                    courseCubit.onPurchase(context, enrolledCourse);
                  } catch (e) {
                    log('Error in onPurchase: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update course: $e'), backgroundColor: Colors.red),
                    );
                  }
                },
              ),
            ),
            BlocProvider<CourseCubit>.value(value: courseCubit),
          ],
          child: BlocListener<EnrollmentBloc, EnrollmentState>(
            listener: (context, state) {
              if (state is EnrollmentSuccess) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully enrolled!'), backgroundColor: Colors.green),
                );
              } else if (state is EnrollmentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            child: EnrollmentBottomSheet(
              course: course,
              userId: userId,
              onEnrollmentSuccess: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      );
    } catch (e) {
      log('Error showing enrollment sheet: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open enrollment: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/payment/data/models/add_purchase_params.dart';

abstract class EnrollmentEvent {}

class StartPaymentEvent extends EnrollmentEvent {
  final CourseEntity course;
  final String userEmail;
  final AddPurchaseParams params;

  StartPaymentEvent({
    required this.course,
    required this.userEmail,
    required this.params,
  });
}

class EnrollFreeCourseEvent extends EnrollmentEvent {
  final CourseEntity course;
  final AddPurchaseParams params;

  EnrollFreeCourseEvent({required this.course,required this.params});
}
class PaymentSuccessEvent extends EnrollmentEvent {
  final PaymentSuccessResponse response;
  final AddPurchaseParams params;

  PaymentSuccessEvent(this.response, {required this.params});
}

class PaymentErrorEvent extends EnrollmentEvent {
  final PaymentFailureResponse response;

  PaymentErrorEvent(this.response);
}

class ExternalWalletEvent extends EnrollmentEvent {
  final ExternalWalletResponse response;

  ExternalWalletEvent(this.response);
}

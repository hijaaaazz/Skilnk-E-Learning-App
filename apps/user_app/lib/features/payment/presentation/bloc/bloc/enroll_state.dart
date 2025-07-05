import  'package:user_app/features/payment/data/models/add_purchase_params.dart';

abstract class EnrollmentState {}

class EnrollmentInitial extends EnrollmentState {}

class EnrollmentProcessing extends EnrollmentState {
  final AddPurchaseParams? params;

  EnrollmentProcessing({this.params});
}

class EnrollmentSuccess extends EnrollmentState {}

class EnrollmentError extends EnrollmentState {
  final String message;

  EnrollmentError(this.message);
}

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/payment/data/models/add_purchase_params.dart';
import  'package:user_app/features/payment/domain/usecase/enroll_course.dart';
import  'package:user_app/features/payment/presentation/bloc/bloc/enroll_event.dart';
import  'package:user_app/features/payment/presentation/bloc/bloc/enroll_state.dart';
import  'package:user_app/service_locator.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  late Razorpay _razorpay;
  final Function(CourseEntity)? onPurchaseSuccess;

  EnrollmentBloc({this.onPurchaseSuccess}) : super(EnrollmentInitial()) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    on<StartPaymentEvent>(_onStartPayment);
    on<EnrollFreeCourseEvent>(_onEnrollFreeCourse);
    on<PaymentSuccessEvent>(_onPaymentSuccess);
    on<PaymentErrorEvent>(_onPaymentError);
    on<ExternalWalletEvent>(_onExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (state is EnrollmentProcessing) {
      final currentState = state as EnrollmentProcessing;
      final params = currentState.params;
      if (params != null) {
        add(PaymentSuccessEvent(
          response,
          params: params.copyWith(
            purchaseId: response.paymentId,
          ),
        ));
      } else {
        log('Error: No params available in EnrollmentProcessing state');
        add(PaymentErrorEvent(PaymentFailureResponse(
          -1,
          'Invalid state: No purchase parameters available',
          null,
        )));
      }
    } else {
      log('Error: Payment success received in invalid state: ${state.runtimeType}');
      add(PaymentErrorEvent(PaymentFailureResponse(
        -1,
        'Invalid state for payment success',
        null,
      )));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    add(PaymentErrorEvent(response));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    add(ExternalWalletEvent(response));
  }

  Future<void> _onStartPayment(
      StartPaymentEvent event, Emitter<EnrollmentState> emit) async {
    final discountedPrice = event.course.offerPercentage > 0
        ? _calculateDiscountedPrice(
            event.course.price, event.course.offerPercentage)
        : event.course.price;

    final params = AddPurchaseParams(
      courseId: event.course.id,
      userId: event.params.userId,
      tutorId: event.course.tutorId,
      amount: discountedPrice.toDouble(),
      purchaseId: null,
    );

    emit(EnrollmentProcessing(params: params));

    var options = {
      'key': 'rzp_test_u0InZg6uQWZDgB', 
      'amount': discountedPrice * 100, 
      'name': 'Course Enrollment',
      'description': 'Enrollment for ${event.course.title}',
      'prefill': {'email': event.userEmail},
      'theme': {'color': '#FF6636'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log(e.toString());
      emit(EnrollmentError('Failed to initiate payment'));
    }
  }

  Future<void> _onEnrollFreeCourse(
      EnrollFreeCourseEvent event, Emitter<EnrollmentState> emit) async {
    emit(EnrollmentProcessing(params: event.params));

    try {
      final result = await serviceLocator<EnrollCoursesUseCase>().call(
        params: event.params.copyWith(
          purchaseId: null, // Ensure purchaseId is null for free courses
        ),
      );

      result.fold(
        (error) {
          log('Free course enrollment failed: $error');
          emit(EnrollmentError('Failed to enroll in free course: $error'));
        },
        (course) {
          log('Free course enrollment successful for course: ${course.title}');
          emit(EnrollmentSuccess());

          // 🎯 Call the callback function
          try {
            onPurchaseSuccess?.call(course);
          } catch (e) {
            log('Error in onPurchaseSuccess callback: $e');
          }
        },
      );
    } catch (e) {
      log('Exception in free course enrollment: $e');
      emit(EnrollmentError('An unexpected error occurred'));
    }
  }

  Future<void> _onPaymentSuccess(
      PaymentSuccessEvent event, Emitter<EnrollmentState> emit) async {
    log('Payment Success: ${event.response.paymentId}');

    try {
      // Call enrollment use case with payment ID
      final result = await serviceLocator<EnrollCoursesUseCase>().call(
        params: event.params,
      );

      result.fold(
        (error) {
          log('Enrollment failed after payment: $error');
          emit(EnrollmentError('Enrollment failed: $error'));
        },
        (course) {
          log('Enrollment successful for course: ${course.title}');
          emit(EnrollmentSuccess());
          
          // 🎯 Call the callback function
          try {
            onPurchaseSuccess?.call(course);
          } catch (e) {
            log('Error in onPurchaseSuccess callback: $e');
          }
        },
      );
    } catch (e) {
      log('Exception in payment success: $e');
      emit(EnrollmentError('An unexpected error occurred'));
    }
  }

  Future<void> _onPaymentError(
      PaymentErrorEvent event, Emitter<EnrollmentState> emit) async {
    log('Payment Error: ${event.response.code} - ${event.response.message}');
    emit(EnrollmentError('Payment failed: ${event.response.message}'));
  }

  Future<void> _onExternalWallet(
      ExternalWalletEvent event, Emitter<EnrollmentState> emit) async {
    log('External Wallet: ${event.response.walletName}');
    // No state change needed for external wallet selection
  }

  int _calculateDiscountedPrice(int originalPrice, int discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) {
      return originalPrice;
    }
    final discount = (originalPrice * discountPercentage) ~/ 100;
    return originalPrice - discount;
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
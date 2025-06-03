import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/payment/data/models/add_purchase_params.dart';
import 'package:user_app/features/payment/presentation/bloc/bloc/enroll_bloc.dart';
import 'package:user_app/features/payment/presentation/bloc/bloc/enroll_event.dart';
import 'package:user_app/features/payment/presentation/bloc/bloc/enroll_state.dart';

class EnrollmentBottomSheet extends StatelessWidget {
  final CourseEntity course;
  final String userId;
  final VoidCallback? onEnrollmentSuccess;

  const EnrollmentBottomSheet({
    super.key,
    required this.course,
    required this.userId,
    this.onEnrollmentSuccess,
  });

  // Static method to show the bottom sheet
  static void show(
    BuildContext context, {
    required CourseEntity course,
    required String userId,
    VoidCallback? onEnrollmentSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => EnrollmentBottomSheet(
        course: course,
        userId: userId,
        onEnrollmentSuccess: onEnrollmentSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnrollmentBloc, EnrollmentState>(
      listener: (context, state) {
        if (state is EnrollmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is EnrollmentSuccess) {
          HapticFeedback.lightImpact();
          // Fix: Check if the widget is still mounted before navigating
          Future.delayed(const Duration(milliseconds: 1500), () {
            // Check if the context is still valid and the widget is mounted
            if (context.mounted) {
              onEnrollmentSuccess?.call();
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            if (state is EnrollmentSuccess) {
              return _buildSuccessView();
            }
            return _buildSheetContent(context, state is EnrollmentProcessing);
          },
        ),
      ),
    );
  }

  Widget _buildSheetContent(BuildContext context, bool isProcessing) {
    final isFreeCourse = course.price == 0;
    final discountedPrice = course.offerPercentage > 0
        ? _calculateDiscountedPrice(course.price, course.offerPercentage)
        : course.price;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 24),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6636), Color(0xFFFF8A50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF6636).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enroll in Course',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      'Confirm your enrollment',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Course Info Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8F1FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      course.courseThumbnail,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF202244),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.averageRating}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.lessons.length} lessons',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isFreeCourse) ...[
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE8F1FF)),
                const SizedBox(height: 16),

                // Price Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (course.offerPercentage > 0) ...[
                          Text(
                            '₹${course.price}',
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${course.offerPercentage}% OFF',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹$discountedPrice',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF6636),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            '₹${course.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6636),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Main Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isProcessing
                      ? null
                      : () {
                          if (isFreeCourse) {
                            context.read<EnrollmentBloc>().add(EnrollFreeCourseEvent(
                              course: course,
                              params: AddPurchaseParams(
                                courseId: course.id,
                                userId: userId,
                                tutorId: course.tutorId,
                                purchaseId: null,
                                amount: discountedPrice.toDouble()
                              ),
                            ));
                          } else {
                            final userEmail = context.read<AuthStatusCubit>().state.user!.email;
                            context.read<EnrollmentBloc>().add(
                                  StartPaymentEvent(
                                    course: course,
                                    userEmail: userEmail,
                                    params: AddPurchaseParams(
                                      courseId: course.id,
                                      userId: userId,
                                      tutorId: course.tutorId,
                                      amount: discountedPrice.toDouble(),
                                      purchaseId: null, // Will be updated on success
                                    ),
                                  ),
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6636),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: const Color(0xFFFF6636).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isFreeCourse ? 'Processing...' : 'Processing Payment...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFreeCourse ? Icons.school : Icons.payment,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isFreeCourse
                                  ? 'Enroll Now - Free'
                                  : 'Pay ₹$discountedPrice & Enroll',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              TextButton(
                onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),

        // Success Animation
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        Text(
          'Enrollment Successful!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'You have successfully enrolled in the course. You can now access all course materials.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  int _calculateDiscountedPrice(int originalPrice, int discountPercentage) {
    if (discountPercentage <= 0 || discountPercentage > 100) {
      return originalPrice;
    }
    final discount = (originalPrice * discountPercentage) ~/ 100;
    return originalPrice - discount;
  }
}
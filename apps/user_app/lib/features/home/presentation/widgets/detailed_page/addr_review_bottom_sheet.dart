import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_cubit.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';

class AddReviewBottomSheet extends StatefulWidget {
  final String courseId;
 

  const AddReviewBottomSheet({
    super.key,
    required this.courseId,
  
  });

  static void show({
    required BuildContext context,
    required String courseId,
    required String reviewerName,
    required String reviewerImage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddReviewBottomSheet(
        courseId: courseId,
        
      ),
    );
  }

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    if (_rating == 0 || _reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating and review'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final review = ReviewModel(
      courseId: widget.courseId,
      likes: [],
      rating: _rating,
      reviewerName: context.read<AuthStatusCubit>().state.user!.name,
      reviewerImage: context.read<AuthStatusCubit>().state.user!.image?? "",
      review: _reviewController.text.trim(),
      reviewedAt: DateTime.now(),
    );

    context.read<CourseCubit>().addReview(context, review);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFF6636),
                  size: 36,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          // Review Text Field
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts about the course',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _submitReview(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6636),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit Review',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
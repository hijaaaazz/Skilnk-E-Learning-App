import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';

class ActionButton extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;

  const ActionButton({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: InkWell(
        onTap: onTap,
        child: course.isEnrolled ? _buildGoToCourseButton() : _buildEnrollButton(),
      ),
    );
  }

  Widget _buildGoToCourseButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(30),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_filled, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text('Go to Course', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildEnrollButton() {
    String buttonText = 'Enroll Course';
    if (course.price > 0) {
      final price = course.offerPercentage > 0 && course.offerPercentage <= 100
          ? course.price - ((course.price * course.offerPercentage) ~/ 100)
          : course.price;
      buttonText = 'Enroll Course - ₹$price';
    } else {
      buttonText = 'Enroll Course - Free';
    }
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6636),
        borderRadius: BorderRadius.circular(30),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: const Color(0xFFFF6636).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Center(child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
    );
  }
}
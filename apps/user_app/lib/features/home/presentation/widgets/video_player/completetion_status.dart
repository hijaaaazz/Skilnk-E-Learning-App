import 'package:flutter/material.dart';
import 'package:user_app/common/widgets/app_text.dart';

class IsCompletedBadge extends StatelessWidget {
  final bool isCompleted;

  const IsCompletedBadge({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCompleted) return const SizedBox(); // Nothing if not completed

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade400,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 6),
             AppText(
              text: "Completed",
              color: Colors.white,
              size: 13,
              weight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

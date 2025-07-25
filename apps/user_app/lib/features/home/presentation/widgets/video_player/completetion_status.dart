import 'package:flutter/material.dart';

class IsCompletedBadge extends StatelessWidget {
  final bool isCompleted;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;

  const IsCompletedBadge({
    super.key,
    required this.isCompleted,
    this.margin,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCompleted) return const SizedBox.shrink();

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            "Completed",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

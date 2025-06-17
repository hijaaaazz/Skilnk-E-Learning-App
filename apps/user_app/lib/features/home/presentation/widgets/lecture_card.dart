import 'package:flutter/material.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';

class LectureCard extends StatelessWidget {
  final LectureProgressModel lecture;
  final VoidCallback onTap;

  const LectureCard({
    super.key,
    required this.lecture,
    required this.onTap,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAccessible = !lecture.isLocked;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isAccessible ? Colors.white : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: lecture.isCompleted
                ? const Color(0xFF4CAF50)
                : isAccessible
                    ? const Color(0xFFE8F1FF)
                    : const Color(0xFFE0E0E0),
            width: 2,
          ),
          boxShadow: isAccessible
              ? [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Lecture number and status icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: lecture.isCompleted
                    ? const Color(0xFF4CAF50)
                    : lecture.isLocked
                        ? const Color(0xFF9E9E9E)
                        : const Color(0xFFFF6636),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (lecture.isCompleted
                            ? const Color(0xFF4CAF50)
                            : lecture.isLocked
                                ? const Color(0xFF9E9E9E)
                                : const Color(0xFFFF6636))
                        // ignore: deprecated_member_use
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: lecture.isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 26,
                      )
                    : lecture.isLocked
                        ? const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 22,
                          )
                        : Text(
                            '${lecture.index}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Lecture details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.lecture.title,
                    style: TextStyle(
                      color: isAccessible
                          ? const Color(0xFF202244)
                          : const Color(0xFF9E9E9E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 18,
                        color: isAccessible
                            ? const Color(0xFF545454)
                            : const Color(0xFFBDBDBD),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDuration(lecture.lecture.duration),
                        style: TextStyle(
                          color: isAccessible
                              ? const Color(0xFF545454)
                              : const Color(0xFFBDBDBD),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      if (!lecture.isCompleted && !lecture.isLocked && lecture.watchedDuration.inSeconds > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6636),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatDuration(lecture.watchedDuration)} watched',
                          style: const TextStyle(
                            color: Color(0xFFFF6636),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  if (!lecture.isCompleted && !lecture.isLocked && lecture.progressPercentage > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: const Color(0xFFF0F0F0),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: lecture.progressPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xFFFF6636),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Action icon
            Icon(
              lecture.isCompleted
                  ? Icons.replay
                  : lecture.isLocked
                      ? Icons.lock
                      : Icons.play_arrow,
              color: lecture.isCompleted
                  ? const Color(0xFF4CAF50)
                  : lecture.isLocked
                      ? const Color(0xFF9E9E9E)
                      : const Color(0xFFFF6636),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/presentation/widgets/utils.dart';

class LectureCard extends StatelessWidget {
  final int index;
  final LectureCreationReq lecture;

  const LectureCard({
    super.key,
    required this.index,
    required this.lecture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8EAEF),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lecture.title ?? 'Untitled Lecture',
                style: const TextStyle(
                  color: Color(0xFF1D1F26),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            lecture.description ?? 'No description',
            style: const TextStyle(
              color: Color(0xFF4D5565),
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          if (lecture.videoUrl != null && lecture.videoUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.video_library_outlined,
                  size: 16,
                  color: Color(0xFF8C93A3),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Video:',
                  style: TextStyle(
                    color: Color(0xFF8C93A3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        getFileName(lecture.videoUrl!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(formatDuration(lecture.duration!))
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Color(0xFF8C93A3),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Lecture Notes:',
                  style: TextStyle(
                    color: Color(0xFF8C93A3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    getFileName(lecture.notesUrl!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
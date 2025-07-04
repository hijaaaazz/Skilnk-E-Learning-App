import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/presentation/widgets/instructor_card.dart';
import 'package:user_app/features/home/presentation/widgets/section_tile.dart';

class InstructorSection extends StatelessWidget {
  final MentorEntity mentor;

  const InstructorSection({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Instructor'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InstructorCard(mentor: mentor),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
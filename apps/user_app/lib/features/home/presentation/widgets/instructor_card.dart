
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class InstructorCard extends StatelessWidget {
  final MentorEntity mentor;
  

  const InstructorCard({
    super.key,
    required this.mentor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(mentor.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            context.pushNamed(AppRouteConstants.mentordetailsPaage, extra: mentor);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mentor.name,
                style: const TextStyle(
                  color: Color(0xFF202244),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              
            ],
          ),
        ),
      ],
    );
  }
}
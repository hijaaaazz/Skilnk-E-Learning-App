import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_event.dart';

class MentorActions extends StatelessWidget {
  final String mentorId;

  const MentorActions({super.key, required this.mentorId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              context.read<MentorDetailsBloc>().add(ChatWithMentor(mentorId));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6636),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6636).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
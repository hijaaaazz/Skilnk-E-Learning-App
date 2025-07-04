import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_event.dart';

class MentorActions extends StatelessWidget {
  final MentorEntity mentor;

  const MentorActions({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        // Message Button
        Expanded(
          flex: 2,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.pushNamed(
                    AppRouteConstants.chatPaage,
                    extra: mentor,
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Start Conversation',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
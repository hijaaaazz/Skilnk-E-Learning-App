import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_event.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_state.dart';

class ProfileSection extends StatelessWidget {
  final MentorDetailsLoaded state;

  const ProfileSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: state.mentor.imageUrl.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      state.mentor.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            state.mentor.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202244),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.mentor.specialization,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF545454),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(context, state.mentor.sessions.length.toString(), 'Courses'),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              _buildStatItem(context, '15800', 'Students'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<MentorDetailsBloc>().add(ChatWithMentor(state.mentor.id));
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202244),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF545454),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class MentorProfileHeader extends StatelessWidget {
  final MentorEntity mentor;

  const MentorProfileHeader({super.key, required this.mentor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: mentor.imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    mentor.imageUrl,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          mentor.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202244),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          mentor.specialization,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF545454),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
import 'package:user_app/features/explore/presentation/widgets/course_tile.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_event.dart';
import 'package:user_app/features/home/presentation/bloc/mentor_bloc/mentor_state.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_page/bio_section.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_page/courses_section.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_page/mentor_actions.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_page/skelton.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';

class MentorDetailsPage extends StatelessWidget {
  final MentorEntity mentor;

  const MentorDetailsPage({
    super.key,
    required this.mentor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorDetailsBloc()
        ..add(LoadMentorDetails(mentor))
        ..add(LoadMentorCourses(mentor.sessions, mentor)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: BlocConsumer<MentorDetailsBloc, MentorDetailsState>(
          listener: (context, state) {
            if (state is ChatInitiated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat with ${mentor.name} initiated'),
                  backgroundColor: const Color(0xFFFF6B35),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MentorDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B35),
                  strokeWidth: 3,
                ),
              );
            }
            if (state is MentorDetailsLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MentorDetailsLoaded state) {
    return CustomScrollView(
      slivers: [
        SkilnkAppBar(title: ""),
       
        // Content
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildModernProfileSection(context, state),
              if (state.mentor.bio.isNotEmpty)
                BioSection(bio: state.mentor.bio),
              if (state is MentorsCoursesLoadedState)
                CoursesSection(
                  courses: state.courses,
                  sessionIds: mentor.sessions,
                  mentorName: mentor.name,
                ),
              if (state is MentorsCoursesLoadingState)
                buildCoursesSkeletonSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernProfileSection(BuildContext context, MentorDetailsLoaded state) {
    return Container(
      transform: Matrix4.translationValues(0, -60, 0),
      child: Column(
        children: [
          // Profile Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Profile Image
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: state.mentor.imageUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                state.mentor.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                state.mentor.name.isNotEmpty
                                    ? state.mentor.name[0].toUpperCase()
                                    : 'M',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D4AA), Color(0xFF00E5BB)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Name
                Text(
                  state.mentor.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Specialization
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    state.mentor.specialization.join(' • '),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                // Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModernStatItem(
                        state.mentor.sessions.length.toString(),
                        'Courses',
                        Icons.school_rounded,
                      ),
                     
                      
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Action Button
                MentorActions(mentor: state.mentor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
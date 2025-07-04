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
        appBar: SkilnkAppBar(title: ""),
        backgroundColor: const Color(0xFFFAFAFA),
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
                  strokeWidth: 2,
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
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildResponsiveProfileSection(context, state),
              if (state.mentor.bio.isNotEmpty)
                BioSection(bio: state.mentor.bio),
              if (state is MentorsCoursesLoadedState)
                CoursesSection(
                  courses: state.courses,
                  sessionIds: mentor.sessions,
                  mentorName: mentor.name,
                  totalCourse: mentor.sessions.length,
                ),
              if (state is MentorsCoursesLoadingState)
                buildCoursesSkeletonSection(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveProfileSection(BuildContext context, MentorDetailsLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;

    // Responsive values
    final horizontalMargin = isSmallScreen ? 20.0 : (isMediumScreen ? 24.0 : 28.0);
    final cardPadding = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final avatarSize = isSmallScreen ? 80.0 : (isMediumScreen ? 90.0 : 100.0);
    final nameSize = isSmallScreen ? 22.0 : (isMediumScreen ? 24.0 : 26.0);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(horizontalMargin, 20, horizontalMargin, 24),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Profile Image and Info Row
              Row(
                children: [
                  _buildAvatar(state, avatarSize),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.mentor.name,
                          style: TextStyle(
                            fontSize: nameSize,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Specialization
                        _buildSpecialization(state, isSmallScreen),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Action Button (moved up)
              MentorActions(mentor: state.mentor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(MentorDetailsLoaded state, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFF6B35),
                  const Color(0xFFFF6B35).withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
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
                      style: TextStyle(
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialization(MentorDetailsLoaded state, bool isSmallScreen) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: state.mentor.specialization.take(3).map((item) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 10 : 12,
            vertical: isSmallScreen ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              color: const Color(0xFFFF6B35),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }


}
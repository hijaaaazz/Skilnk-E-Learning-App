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
import 'package:user_app/features/home/presentation/widgets/mentor_page/skelton.dart';

// Main Widget
class MentorDetailsPage extends StatelessWidget {
  final MentorEntity mentor;
  
  const MentorDetailsPage({
    super.key,
    required this.mentor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MentorDetailsBloc()..add(LoadMentorDetails(mentor))..add(LoadMentorCourses(mentor.sessions,mentor)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<MentorDetailsBloc, MentorDetailsState>(
          listener: (context, state) {
            if (state is ChatInitiated) {
              // Navigate to chat screen or show dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Chat with ${mentor.name} initiated')),
              );
            }
          },
          builder: (context, state) {
            if (state is MentorDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
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
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileSection(context, state),
            
            if (state.mentor.specialization.isNotEmpty)
              _buildBioSection(context, state.mentor.specialization),
        
            if (state is MentorsCoursesLoadedState)
              _buildCoursesSection(context, state.courses,mentor.sessions,mentor.name),
        
             if (state is MentorsCoursesLoadingState)
             buildCoursesSkeletonSection(context)
          ],
        ),
      )

    );
  }

  Widget _buildProfileSection(BuildContext context, MentorDetailsLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Profile Image
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
          
          // Name
          Text(
            state.mentor.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF202244),
            ),
          ),
          const SizedBox(height: 4),
          
          // Specialization
          Text(
            state.mentor.specialization,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF545454),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(
                context,
                state.mentor.sessions.length.toString(),
                'Courses',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              _buildStatItem(
                context,
                '15800',
                'Students',
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Buttons
          Row(
            children: [
              // Follow Button
             
              
              // Message Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(AppRouteConstants.chatPaage,
                extra: mentor
                );
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

  Widget _buildBioSection(BuildContext context, String bio) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Text(
        '"$bio"',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Color(0xFF545454),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context, List<CoursePreview> courses, List<String> ids,String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: GestureDetector(
            onTap: (){
              context.pushNamed(AppRouteConstants.courselistPaage, extra:  CourseListPageArgs(courseIds: ids, title: "$title's Courses"));
            },
            child: Row(
              children: [
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202244),
                  ),
                ),
                const Spacer(),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Course List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseTile(course: course);
          },
        ),
      ],
    );
  }

}
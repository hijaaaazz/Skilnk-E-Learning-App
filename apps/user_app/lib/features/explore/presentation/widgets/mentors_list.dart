// lib/features/explore/presentation/widgets/mentors_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/explore/presentation/theme.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class MentorsListWidget extends StatelessWidget {
  final List<MentorEntity> mentors;
  
  const MentorsListWidget({
    super.key,
    required this.mentors,
  });

  Widget _buildSkeleton() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
                      surfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
                      color:  Colors.white,
                      shadowColor: Colors.grey,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 1,
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        
                      ),
            child: Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 245, 245, 245),
              highlightColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Avatar skeleton
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name skeleton
                          Container(
                            width: 150,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Specialization skeleton
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Rating skeleton
                          Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Button skeleton
                    Container(
                      width: 60,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildSkeleton();
        }
        return Expanded(
          child: mentors.isEmpty
            ? Center(
                child: Text(
                  'No mentors found',
                  style: TextStyle(color: ExploreTheme.secondaryTextColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: mentors.length,
                itemBuilder: (context, index) {
                  final mentor = mentors[index];
                  
                  return InkWell(
                    onTap: () {
                      context.pushNamed(AppRouteConstants.mentordetailsPaage, extra: mentor);
                    },
                    child: Card(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: ExploreTheme.secondaryColor.withOpacity(0.1),
                              child: Text(
                                mentor.name.substring(0, 1),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ExploreTheme.secondaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mentor.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: ExploreTheme.textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    mentor.specialization,
                                    style: TextStyle(
                                      color: ExploreTheme.secondaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                      Text(
                                        ' ${mentor.rating}',
                                        style: TextStyle(
                                          color: ExploreTheme.secondaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        ' • ',
                                        style: TextStyle(
                                          color: ExploreTheme.secondaryTextColor,
                                          fontSize: 14,
                                        ),
                      ),
                                      Text(
                                        '${mentor.sessions.length} sessions',
                                        style: TextStyle(
                                          color: ExploreTheme.secondaryTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ExploreTheme.secondaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Book',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
      },
    );
  }
}
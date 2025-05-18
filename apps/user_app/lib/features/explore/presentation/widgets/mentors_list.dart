// lib/features/explore/presentation/widgets/mentors_list_widget.dart
import 'package:flutter/material.dart';
import 'package:user_app/features/explore/presentation/theme.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class MentorsListWidget extends StatelessWidget {
  final List<MentorEntity> mentors;
  
  const MentorsListWidget({
    Key? key,
    required this.mentors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: mentors.isEmpty
        ? Center(
            child: Text(
              'No mentors found',
              style: TextStyle(color: ExploreTheme.secondaryTextColor),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade100),
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
              );
            },
          ),
    );
  }
}
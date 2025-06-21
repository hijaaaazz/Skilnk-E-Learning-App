// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:user_app/core/routes/app_route_constants.dart';
// import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
// import 'package:user_app/features/explore/presentation/widgets/course_tile.dart';
// import 'package:user_app/features/home/domain/entity/course_privew.dart';
// import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
// import 'package:user_app/features/home/presentation/bloc/bloc/mentor_state.dart';
// import 'package:user_app/features/home/presentation/widgets/mentor_page/mentor_actions.dart';
// import 'package:user_app/features/home/presentation/widgets/mentor_page/mentor_stats.dart';
// import 'package:user_app/features/home/presentation/widgets/mentor_page/profile_section.dart';
// import 'package:user_app/features/home/presentation/widgets/mentor_page/skelton.dart';

// class MentorContent extends StatelessWidget {
//   final MentorDetailsLoaded state;
//   final MentorEntity mentor;

//   const MentorContent({
//     super.key,
//     required this.state,
//     required this.mentor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             MentorProfileHeader(mentor: state.mentor),
//             const SizedBox(height: 20),
//             MentorStats(
//               coursesCount: state.mentor.sessions.length.toString(),
//               studentsCount: '15800',
//             ),
//             const SizedBox(height: 20),
//             MentorActions(mentorId: state.mentor.id),
//             if (state.mentor.specialization.isNotEmpty)
//               _buildBioSection(context, state.mentor.specialization),
//             if (state is MentorsCoursesLoadedState)
//               _buildCoursesSection(context,state.courses, mentor.sessions, mentor.name),
//             if (state is MentorsCoursesLoadingState)
//               buildCoursesSkeletonSection(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBioSection(BuildContext context, String bio) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F9F9),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.2)),
//       ),
//       child: Text(
//         '"$bio"',
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 14,
//           fontStyle: FontStyle.italic,
//           color: Color(0xFF545454),
//           height: 1.5,
//         ),
//       ),
//     );
//   }

//   Widget _buildCoursesSection(
//       BuildContext context, List<CoursePreview> courses, List<String> ids, String title) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
//           child: GestureDetector(
//             onTap: () {
//               context.pushNamed(AppRouteConstants.courselistPaage,
//                   extra: CourseListPageArgs(courseIds: ids, title: "$title's Courses"));
//             },
//             child: Row(
//               children: [
//                 const Text('Courses',
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF202244))),
//                 const Spacer(),
//                 Text('View All',
//                     style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.blue[700])),
//               ],
//             ),
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: courses.length,
//           itemBuilder: (context, index) => CourseTile(course: courses[index]),
//         ),
//       ],
//     );
//   }
// }
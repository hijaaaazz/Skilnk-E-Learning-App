
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/data/models/search_params_model.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/course_card.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_card.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return 
        

           Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRouteConstants.exploreRouteName,extra:SearchParams(query: "", type: SearchType.course,filter: FilterOption.all) );
                    },
                    child: Row(
                      children: const [
                        Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:

                 BlocBuilder<CourseBlocBloc, CourseBlocState>(
                    builder: (context, state) {
                      if (state is CourseBlocLoading || state is CourseBlocError) {
                        return Row(
                          children: List.generate(2, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: CourseCardSkeleton(),
                            );
                          }),
                        );
                      } else if (state is CourseBlocLoaded) {
                        final courses = state.courses;
                        return Row(
                          children: List.generate(courses.length, (index) {
                            final course = courses[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: CourseCard(
                                course: course,
                                isPartiallyVisible: index == courses.length - 1,
                              ),
                            );
                          }),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )

              )
            ],
          );
  }
}

class MentorsSection extends StatelessWidget {
  const MentorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBlocBloc, CourseBlocState>(
      builder: (context, state) {
       

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mentors',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed(AppRouteConstants.exploreRouteName,extra:SearchParams(query: "", type: SearchType.mentor) );
                    },
                    child: Row(
                      children: const [
                        Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<CourseBlocBloc, CourseBlocState>(
                  builder: (context, state) {
                    if(state is CourseBlocLoaded){
                      final mentors = state.mentors;
                       return Row(
                      children: List.generate(mentors.length, (index) {
                        final mentor = mentors[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: MentorAvatar(
                            mentor: mentor,
                          ),
                        );
                      }),
                    );
                    }else if(state is CourseBlocLoading || state is CourseBlocError){
                      return Row(
                      children: List.generate(5, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: MentorAvatarSkeleton()
                        );
                      }),
                    );
                    }
                    return SizedBox.shrink();
                  },
                
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
      },
    );
  }
}

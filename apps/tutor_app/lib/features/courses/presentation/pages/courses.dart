import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/data/models/course_details_args.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/courses_card.dart';
import 'package:tutor_app/features/courses/presentation/widgets/searchbar.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  //bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(_onScroll);
    
    // Load initial courses
    context.read<CoursesBloc>().add(const LoadCourses());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      context.read<CoursesBloc>().add(const LoadMoreCourses());
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("My Courses")
        // _isSearching 
        //   ? CourseSearchBar(
        //       controller: _searchController,
        //       onChanged: (query) {
        //         context.read<CoursesBloc>().add(SearchCourses(query));
        //       },
        //       onClose: () {
        //         setState(() {
        //           _isSearching = false;
        //           _searchController.clear();
        //         });
        //         context.read<CoursesBloc>().add(const LoadCourses());
        //       },
        //     )
        //   : const Text("My Courses"),
        ,actions: [
          // Search button
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       _isSearching = true;
          //     });
          //   },
          //   icon: const Icon(Icons.search, color: Colors.white),
          // ),
          // Add course button
          IconButton(
            onPressed: () {
              context.pushNamed(AppRouteConstants.addCourse);
            },
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
          ),
        ],
      ),
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CoursesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is CoursesLoading && state.courses.isEmpty) {
            return const Center(child: BlurredLoading());
          }
          
          if (state is CoursesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(const LoadCourses());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          // Get courses from the state
          
          final courses = state is CoursesLoaded 
              ? state.courses 
              : state is CoursesLoading 
                  ? state.courses 
                  : <CourseEntity>[];
          
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No courses found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first course by tapping the + button',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed(AppRouteConstants.addCourse);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Course'),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CoursesBloc>().add(const RefreshCourses());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: courses.length + (state is CoursesLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= courses.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final course = courses[index];
                  return CourseCard(
                    course: course as CoursePreview,
                    onTap: () {
                      final bloc = context.read<CoursesBloc>();
                      log(course.thumbnailUrl);
                      context.pushNamed(
                        AppRouteConstants.courseDetailesRouteName,
                        extra: CourseDetailsArgs(
                          bloc: bloc,
                          courseId: course.id)
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

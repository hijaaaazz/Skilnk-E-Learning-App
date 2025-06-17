import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/course_list/data/models/list_page_arg.dart';
import 'package:user_app/features/course_list/presentation/bloc/course_list_bloc.dart';
import 'package:user_app/features/course_list/presentation/bloc/course_list_event.dart';
import 'package:user_app/features/course_list/presentation/bloc/course_list_state.dart';
import 'package:user_app/features/explore/presentation/widgets/course_tile.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/presentation/widgets/mentor_page/skelton.dart';
import 'package:user_app/presentation/account/widgets/app_bar.dart';
// Import your skeleton widget here
// import 'package:user_app/path/to/your/course_tile_skeleton.dart';

class CourseList extends StatefulWidget {
  final CourseListPageArgs args;

  const CourseList({super.key, required this.args});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final ScrollController _scrollController = ScrollController();
  List<CoursePreview> _allCourses = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController.addListener(_onScroll);
    context.read<CourseListBloc>().add(LoadList(courseIds: widget.args.courseIds));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final currentState = context.read<CourseListBloc>().state;
      if (currentState is CourseListLoaded && !currentState.hasReachedMax && !_isLoadingMore) {
        _isLoadingMore = true;
        context.read<CourseListBloc>().add(FetchPage(courseIds: widget.args.courseIds, pageKey: 1));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Build skeleton loading tiles
  Widget _buildSkeletonTiles(int count) {
    return Column(
      children: List.generate(count, (index) => 
        // Replace with your actual skeleton widget
        CourseTileSkeleton() // Your skeleton widget here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkilnkAppBar(title: widget.args.title),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
        child: BlocConsumer<CourseListBloc, CourseListState>(
          listener: (context, state) {
            if (state is CourseListLoaded) {
              _allCourses = state.courses;
              _isLoadingMore = false;
            } else if (state is CourseListError) {
              _isLoadingMore = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            // Show skeleton tiles on initial loading
            if (state is CourseListLoading) {
              return SingleChildScrollView(
                child: _buildSkeletonTiles(widget.args.courseIds.length <= 7 ? widget.args.courseIds.length : 7 ), // Show 5 skeleton tiles
              );
            }
        
            if (state is CourseListError && _allCourses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CourseListBloc>().add(LoadList(courseIds: widget.args.courseIds));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
        
            if (_allCourses.isEmpty) {
              return const Center(child: Text('No courses available'));
            }
        
            return RefreshIndicator(
              onRefresh: () async {
                _allCourses.clear();
                context.read<CourseListBloc>().add(LoadList(courseIds: widget.args.courseIds));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _allCourses.length + (state is CourseListLoaded && !state.hasReachedMax ? 3 : 0),
                itemBuilder: (context, index) {
                  if (index >= _allCourses.length) {
                    // Show skeleton tiles instead of circular indicator
                    return CourseTileSkeleton(); // Your skeleton widget
                  }
        
                  final course = _allCourses[index];
                  return CourseTile(course: course);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
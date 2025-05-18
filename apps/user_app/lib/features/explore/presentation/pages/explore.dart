// lib/features/explore/presentation/pages/explore_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/explore/presentation/theme.dart';
import 'package:user_app/features/explore/presentation/widgets/category_grid.dart';
import 'package:user_app/features/explore/presentation/widgets/course_filters.dart';
import 'package:user_app/features/explore/presentation/widgets/course_list.dart';
import 'package:user_app/features/explore/presentation/widgets/main_chips.dart';
import 'package:user_app/features/explore/presentation/widgets/mentors_list.dart';
import 'package:user_app/features/explore/presentation/widgets/search_bar.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExplorePageView();
  }
}

class ExplorePageView extends StatefulWidget {
  const ExplorePageView({super.key});

  @override
  State<ExplorePageView> createState() => _ExplorePageViewState();
}

class _ExplorePageViewState extends State<ExplorePageView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Initialize the explore page
    context.read<ExploreBloc>().add(InitializeExplore());
  }

  void _onSearchChanged() {
    context.read<ExploreBloc>().add(SearchExplore(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExploreTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(
            color: ExploreTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ExploreTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
          if (state.isLoading && state.allCourses.isEmpty && state.allMentors.isEmpty && state.allCategories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state.errorMessage != null && state.allCourses.isEmpty && state.allMentors.isEmpty && state.allCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error',
                    style: TextStyle(
                      color: ExploreTheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: ExploreTheme.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExploreBloc>().add(InitializeExplore());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ExploreTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [  
              SearchBarWidget(controller: _searchController),
              MainChipsWidget(
                chips: state.mainChips,
                selectedChip: state.selectedMainChip,
              ),
              if (state.selectedMainChip == 'Courses') 
                const CoursesFiltersWidget(),
              _buildContent(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ExploreState state) {
    if (state.isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Expanded(
        child: Center(
          child: Text(
            state.errorMessage!,
            style: TextStyle(color: ExploreTheme.secondaryTextColor),
          ),
        ),
      );
    }

    switch (state.selectedMainChip) {
      case 'Categories':
        return CategoriesGridWidget(categories: state.filteredCategories);
      case 'Courses':
        return CoursesListWidget(courses: state.filteredCourses);
      case 'Mentors':
        return MentorsListWidget(mentors: state.filteredMentors);
      default:
        return const SizedBox.shrink();
    }
  }
}
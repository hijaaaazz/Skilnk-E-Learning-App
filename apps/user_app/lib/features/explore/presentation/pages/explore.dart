// lib/features/explore/presentation/pages/explore_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/core/debouncer.dart';
import  'package:user_app/features/explore/data/models/search_args.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import  'package:user_app/features/explore/presentation/theme.dart';
import  'package:user_app/features/explore/presentation/widgets/category_grid.dart';
import  'package:user_app/features/explore/presentation/widgets/course_filters.dart';
import  'package:user_app/features/explore/presentation/widgets/course_list.dart';
import  'package:user_app/features/explore/presentation/widgets/main_chips.dart';
import  'package:user_app/features/explore/presentation/widgets/mentors_list.dart';
import  'package:user_app/features/explore/presentation/widgets/search_bar.dart';
import  'package:user_app/presentation/account/widgets/app_bar.dart';

class ExplorePage extends StatelessWidget {
  final SearchParams? queryParams;
  const ExplorePage({super.key,  this.queryParams});

  @override
  Widget build(BuildContext context) {
    return  ExplorePageView(queryParams:queryParams );
  }
}

class ExplorePageView extends StatefulWidget {
  final SearchParams? queryParams;
  const ExplorePageView({super.key,this.queryParams});

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
     context.read<ExploreBloc>().add(InitializeExplore(params : widget.queryParams ?? SearchParams(query: "", type: SearchType.course)));
  }

  @override
void didUpdateWidget(covariant ExplorePageView oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.queryParams != oldWidget.queryParams) {
    context.read<ExploreBloc>().add(InitializeExplore(params:  widget.queryParams?? SearchParams(query: "", type:SearchType.course) ));
  }
}

// In your _ExplorePageViewState class
final Debouncer _debouncer = Debouncer(milliseconds: 200); // 5 seconds

void _onSearchChanged() {
  _debouncer.run(() {
    context.read<ExploreBloc>().add(SearchExplore(_searchController.text));
  });
}

@override
void dispose() {
  _searchController.removeListener(_onSearchChanged);
  _searchController.dispose();
  _debouncer.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExploreTheme.backgroundColor,
      appBar: SkilnkAppBar(title: "Explore"),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
         
          
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
                      context.read<ExploreBloc>().add(InitializeExplore(params: widget.queryParams?? SearchParams(query: "", type: SearchType.course)));
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
                searchController: _searchController,
                chips: state.mainChips,
                selectedChip: state.selectedMainChip,
              ),
              if (state.selectedMainChip == SearchType.course) 
                const CoursesFiltersWidget(),
              _buildContent(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(ExploreState state) {
    

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
      case SearchType.category:
        return CategoriesListWidget(
          searchController: _searchController,
          categories: state.filteredCategories);
      case SearchType.course:
        return CoursesListWidget(courses: state.filteredCourses);
      case SearchType.mentor:
        return MentorsListWidget(mentors: state.filteredMentors);
      
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/explore/data/models/search_args.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import  'package:user_app/features/explore/presentation/theme.dart';

class CoursesFiltersWidget extends StatefulWidget {
  const CoursesFiltersWidget({super.key});

  @override
  State<CoursesFiltersWidget> createState() => _CoursesFiltersWidgetState();
}

class _CoursesFiltersWidgetState extends State<CoursesFiltersWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        // Define filter options
        final Map<FilterOption, String> filters = {
          FilterOption.all: 'All',
          FilterOption.popular: 'Popular',
          FilterOption.recent: 'Recent',
          FilterOption.topRated: 'Top Rated',
          FilterOption.free: 'Free',
          FilterOption.paid: 'Paid',
        };

        // Get the currently selected filter from state
        final selectedFilter = state.selectedFilter;

        // Determine selectedSortOption based on state
        String? selectedSortOption; // No default selection
        IconData sortIcon = Icons.sort;
        
        if (state.selectedSortArgs != null && state.selectedSortOption != null) {
          if (state.selectedSortArgs == SortArgs.price) {
            selectedSortOption = state.selectedSortOption == SortOption.ascending
                ? 'Price: Low to High'
                : 'Price: High to Low';
            sortIcon = state.selectedSortOption == SortOption.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward;
          } else if (state.selectedSortArgs == SortArgs.rating) {
            selectedSortOption = state.selectedSortOption == SortOption.ascending
                ? 'Rating: Low to High'
                : 'Rating: High to Low';
            sortIcon = state.selectedSortOption == SortOption.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward;
          }
        }

        return Column(
          children: [
            // Filters row with sort dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  // Filter chips
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          final filterOption = filters.keys.elementAt(index);
                          final filterLabel = filters[filterOption]!;
                          
                          // Explicitly check if this filter is the selected one from state
                          final isSelected = selectedFilter == filterOption;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              showCheckmark: false,
                              label: Text(filterLabel),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  // Dispatch event to update the selected filter in bloc state
                                  context.read<ExploreBloc>().add(ApplyFilter(filterOption));
                                }
                              },
                              backgroundColor: Colors.white,
                              selectedColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? ExploreTheme.primaryColor : ExploreTheme.secondaryTextColor,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected ? ExploreTheme.primaryColor : Colors.grey.shade200,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              elevation: 0,
                              pressElevation: 0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Sort dropdown with pure white background
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: PopupMenuButton<String>(
                      tooltip: 'Sort options',
                      position: PopupMenuPosition.under,
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sort, size: 18, color: ExploreTheme.secondaryTextColor),
                          if (selectedSortOption != null) const SizedBox(width: 4),
                          if (selectedSortOption != null)
                            Icon(sortIcon, size: 14, color: ExploreTheme.primaryColor),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 4.0,
                      onSelected: (String value) {
                        final isSame = value == selectedSortOption;
                        if (isSame) {
                          // Clear selected sort option
                          context.read<ExploreBloc>().add(ClearSorting());
                        } else {
                          // Apply new sorting
                          SortOption sortOption;
                          SortArgs sortArgs;

                          if (value.contains('Price')) {
                            sortArgs = SortArgs.price;
                            sortOption = value.contains('Low to High') 
                                ? SortOption.ascending 
                                : SortOption.descending;
                          } else {
                            sortArgs = SortArgs.rating;
                            sortOption = value.contains('Low to High') 
                                ? SortOption.ascending 
                                : SortOption.descending;
                          }

                          context.read<ExploreBloc>().add(ApplySorting(sortOption, sortArgs));
                        }
                      },
                      color: Colors.white,
                      shadowColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      itemBuilder: (BuildContext context) {
                        // Explicitly check selected sort option from state
                        return [
                          _buildPopupMenuItem(
                            'Price: Low to High', 
                            state.selectedSortArgs == SortArgs.price && 
                            state.selectedSortOption == SortOption.ascending
                          ),
                          _buildPopupMenuItem(
                            'Price: High to Low', 
                            state.selectedSortArgs == SortArgs.price && 
                            state.selectedSortOption == SortOption.descending
                          ),
                          _buildPopupMenuItem(
                            'Rating: Low to High', 
                            state.selectedSortArgs == SortArgs.rating && 
                            state.selectedSortOption == SortOption.ascending
                          ),
                          _buildPopupMenuItem(
                            'Rating: High to Low', 
                            state.selectedSortArgs == SortArgs.rating && 
                            state.selectedSortOption == SortOption.descending
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Helper method to build styled popup menu items
  PopupMenuItem<String> _buildPopupMenuItem(String text, bool isSelected) {
    return PopupMenuItem<String>(
      value: text,
      height: 40, // More compact height
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? ExploreTheme.primaryColor : ExploreTheme.textColor,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check,
              size: 16,
              color: ExploreTheme.primaryColor,
            ),
        ],
      ),
    );
  }
}
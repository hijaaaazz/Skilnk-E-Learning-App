// lib/features/explore/presentation/widgets/courses_filters_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import 'package:user_app/features/explore/presentation/theme.dart';

class CoursesFiltersWidget extends StatelessWidget {
  const CoursesFiltersWidget({Key? key}) : super(key: key);

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

        final selectedFilter = state.selectedFilter;

        // Determine selectedSortOption based on state
        String selectedSortOption = 'Price: Low to High'; // Default
        if (state.selectedSortArgs != null && state.selectedSortOption != null) {
          if (state.selectedSortArgs == SortArgs.price) {
            selectedSortOption = state.selectedSortOption == SortOption.ascending
                ? 'Price: Low to High'
                : 'Price: High to Low';
          } else if (state.selectedSortArgs == SortArgs.rating) {
            selectedSortOption = state.selectedSortOption == SortOption.ascending
                ? 'Rating: Low to High'
                : 'Rating: High to Low';
          }
        }

        return Column(
          children: [
            // Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  Text(
                    'Filter:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ExploreTheme.textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          final filterOption = filters.keys.elementAt(index);
                          final filterLabel = filters[filterOption]!;
                          final isSelected = filterOption == selectedFilter;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(filterLabel),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<ExploreBloc>().add(ApplyFilter(filterOption));
                                }
                              },
                              backgroundColor: ExploreTheme.backgroundColor,
                              selectedColor: ExploreTheme.primaryColor.withOpacity(0.1),
                              checkmarkColor: ExploreTheme.primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected ? ExploreTheme.primaryColor : ExploreTheme.secondaryTextColor,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected ? ExploreTheme.primaryColor : Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sort options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Sort by:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ExploreTheme.textColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSortOption,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: ExploreTheme.secondaryTextColor),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              SortOption sortOption;
                              SortArgs sortArgs;

                              if (newValue.contains('Price')) {
                                sortArgs = SortArgs.price;
                                sortOption = newValue.contains('Low to High') 
                                    ? SortOption.ascending 
                                    : SortOption.descending;
                              } else {
                                sortArgs = SortArgs.rating;
                                sortOption = newValue.contains('Low to High') 
                                    ? SortOption.ascending 
                                    : SortOption.descending;
                              }

                              context.read<ExploreBloc>().add(ApplySorting(sortOption, sortArgs));
                            }
                          },
                          items: [
                            'Price: Low to High',
                            'Price: High to Low',
                            'Rating: Low to High',
                            'Rating: High to Low',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: ExploreTheme.textColor,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
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
}
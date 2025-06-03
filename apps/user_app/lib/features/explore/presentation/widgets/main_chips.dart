import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:user_app/features/explore/data/models/search_args.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/theme.dart';

class MainChipsWidget extends StatelessWidget {
  final List<SearchType> chips;
  final SearchType selectedChip;
  final TextEditingController searchController;

  const MainChipsWidget({
    Key? key,
    required this.chips,
    required this.searchController,
    required this.selectedChip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExploreBloc bloc = context.read<ExploreBloc>();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = chip == selectedChip;

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                bloc.add(SelectMainChip(chip));
                switch (chip) {
                  case SearchType.course:
                    searchController.text = bloc.state.coursesQuery;
                    break;
                  case SearchType.mentor:
                    searchController.text = bloc.state.mentorsQuery;
                    break;
                  case SearchType.category:
                    searchController.text = bloc.state.categoriesQuery;
                    break;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ExploreTheme.secondaryColor
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ReCase(chip.toString().split('.').last).titleCase,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// lib/features/explore/presentation/widgets/main_chips_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import 'package:user_app/features/explore/presentation/theme.dart';

class MainChipsWidget extends StatelessWidget {
  final List<String> chips;
  final String selectedChip;
  
  const MainChipsWidget({
    Key? key,
    required this.chips,
    required this.selectedChip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = chip == selectedChip;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ChoiceChip(
              label: Text(chip),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<ExploreBloc>().add(SelectMainChip(chip));
                }
              },
              backgroundColor: ExploreTheme.backgroundColor,
              selectedColor: ExploreTheme.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? ExploreTheme.primaryColor : ExploreTheme.secondaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: isSelected ? ExploreTheme.primaryColor : Colors.grey.shade200,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: isSelected ? 0 : 0,
              pressElevation: 0,
            ),
          );
        },
      ),
    );
  }
}
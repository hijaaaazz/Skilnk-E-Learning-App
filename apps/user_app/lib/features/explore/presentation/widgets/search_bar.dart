// lib/features/explore/presentation/widgets/search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_bloc.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_event.dart';
import  'package:user_app/features/explore/presentation/bloc/explore_state.dart';
import  'package:user_app/features/explore/presentation/theme.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  
  const SearchBarWidget({
    super.key,
    required this.controller,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        String hintText = 'Search ${ReCase(state.selectedMainChip.toString().split('.').last.toLowerCase()).titleCase}...';
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: ExploreTheme.secondaryTextColor, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: ExploreTheme.secondaryTextColor, size: 20),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: ExploreTheme.secondaryTextColor, size: 20),
                      onPressed: () {
                        widget.controller.clear();
                        context.read<ExploreBloc>().add(SearchExplore(''));
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(color: ExploreTheme.textColor, fontSize: 14),
          ),
        );
      },
    );
  }
}
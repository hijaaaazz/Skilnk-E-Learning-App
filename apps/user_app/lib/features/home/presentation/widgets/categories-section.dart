
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/explore/data/models/search_args.dart';
import  'package:user_app/features/explore/data/models/search_params_model.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_state.dart';
import  'package:user_app/features/home/presentation/widgets/category_chip.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(AppRouteConstants.exploreRouteName,
                extra: SearchParams(query: "", type: SearchType.category));
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
        const SizedBox(height: 12),
        BlocBuilder<CourseBlocBloc, CourseBlocState>(
  builder: (context, state) {
     if (state is CourseBlocLoading || state is CourseBlocError) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CategoryChipSkeleton(width: 100,),
            );
          }),
        ),
      );
    } else if (state is CourseBlocLoaded) {
      final categories = state.categories;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CategoryChip(
                category: category,
              ),
            );
          }),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  },
)

      ],
    );
  }
}

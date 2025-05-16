
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/course_bloc_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/category_chip.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

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
              onPressed: () {},
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
            if (state is CourseBlocLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseBlocLoaded) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.categories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final category = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: CategoryChip(
                        label: category.title,
                        isSelected: index == 1, // Example: Select second category
                      ),
                    );
                  }).toList(),
                ),
              );
            } else if (state is CourseBlocError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

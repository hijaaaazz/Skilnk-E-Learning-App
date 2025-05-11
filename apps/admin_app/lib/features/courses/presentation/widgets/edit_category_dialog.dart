import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/presentation/bloc/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoryDialog {
  static void show({
    required BuildContext context,
    required CategoryEntity category,
  }) {
    final TextEditingController nameController =
        TextEditingController(text: category.title);
    final TextEditingController descriptionController =
        TextEditingController(text: category.description);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Edit Category',
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepOrange,
                backgroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Category name is required')),
                  );
                  return;
                }

                Navigator.of(dialogContext).pop();

                context.read<CategoryManagementCubit>().updateCategory(
                  category.copyWith(
                    title: name,
                    description: description,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:admin_app/features/courses/data/models/category_model.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/presentation/bloc/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddCategoryDialog {
  static void show({
    required BuildContext context,
  }) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    
    // Store a reference to the CategoryManagementCubit before opening the dialog

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Add Category',
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
                context.read<CategoryManagementCubit>().createCategory(
                  name,description
                );
                
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
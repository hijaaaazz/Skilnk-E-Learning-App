import 'package:admin_app/common/widgets/dialog.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/presentation/bloc/cubit/category_cubit.dart';
import 'package:admin_app/features/courses/presentation/bloc/cubit/category_state.dart';
import 'package:admin_app/features/courses/presentation/widgets/add_category_dialog.dart';
import 'package:admin_app/features/courses/presentation/widgets/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryManagementCubit()..displayCategories(),
      child: const _CategoryPageScaffold(),
    );
  }
}

class _CategoryPageScaffold extends StatelessWidget {
  const _CategoryPageScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CategoryManagementCubit, CategoryManagementState>(
        listener: (context, state) {
          // Handle state changes that require user feedback
         if(state.message != null){
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? "Loading error"),
                backgroundColor: Colors.red,
              ),
            );
         }
        },
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoriesLoadingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<CategoryManagementCubit>().displayCategories(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

 
          
          return _CategoryPageContent(categories: state.categories);
        },
      ),
    );
  }
}

class _CategoryPageContent extends StatelessWidget {
  final List<CategoryEntity> categories;

  const _CategoryPageContent({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  letterSpacing: -0.2,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  AddCategoryDialog.show(
                    context: context,
                    
                  
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Create New Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6636),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories found. Create your first category!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6E7484),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    (index + 1).toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      color: Color(0xFF1D1F26),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    color: Color(0xFF1D1F26),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Tooltip(
                                  message: category.isVisible == true ? "Hide category" : "Show category",
                                  child: IconButton(
                                    icon: Icon(
                                      category.isVisible == true ? Icons.visibility : Icons.visibility_off,
                                      color: category.isVisible == true ? Colors.green : Colors.grey,
                                    ),
                                    onPressed: () {
                                      context.read<CategoryManagementCubit>().updateCategory(
                                            category.copyWith(isVisible: !(category.isVisible ?? true)),
                                          );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: "Edit category",
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      EditCategoryDialog.show(
                                        context: context,
                                        category: category,
                                        
                                      );
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: "Delete category",
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      CustomDialog.show(
                                        context: context,
                                        title: 'Delete Category',
                                        content: Text('Are you sure you want to delete "${category.title}"?'),
                                        onDone: () {
                                          context.read<CategoryManagementCubit>().deleteCategory(category);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '© 2024 - Skilnk.',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                        letterSpacing: -0.14,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                    ),
                    TextSpan(
                      text: 'All rights reserved',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to FAQs page
                    },
                    child: const Text(
                      'FAQs',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      // Navigate to Privacy Policy page
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      // Navigate to Terms & Conditions page
                    },
                    child: const Text(
                      'Terms & Condition',
                      style: TextStyle(
                        color: Color(0xFF6E7484),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.57,
                        letterSpacing: -0.14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
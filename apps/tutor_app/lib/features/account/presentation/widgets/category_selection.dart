import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_cubit.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';


class CategorySelectionBottomSheet extends StatefulWidget {
  final List<String> selectedCategories;

  const CategorySelectionBottomSheet({
    super.key,
    required this.selectedCategories,
  });

  static void show(BuildContext context, {required List<String> selectedCategories}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySelectionBottomSheet(
        selectedCategories: selectedCategories,
      ),
    );
  }

  @override
  State<CategorySelectionBottomSheet> createState() => _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState extends State<CategorySelectionBottomSheet> {
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = widget.selectedCategories.toSet();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ProfileCubit>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Teaching Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final availableCategories = state is ProfileCategoriesUpdated
                  ? state.categories
                  : (state.userCategories ?? []);

              if (state is ProfileCategoriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF5722),
                  ),
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().loadCategories();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5722),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose categories that match your expertise (${_selectedCategories.length} selected)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: availableCategories.length,
                          itemBuilder: (context, index) {
                            final category = availableCategories[index];
                            final isSelected = _selectedCategories.contains(category);
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCategories.remove(category);
                                    // final categoryModel = CategoryModel(title: category);
                                    // context.read<ProfileCubit>().deleteCategory(
                                    //       tutorId: context.read<AuthBloc>().state.user!.tutorId,
                                    //       category: categoryModel,
                                    //       context: context,
                                    //     );
                                  } else {
                                    _selectedCategories.add(category);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? const Color(0xFFFF5722) 
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected 
                                        ? const Color(0xFFFF5722) 
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final tutorId = context.read<AuthBloc>().state.user!.tutorId;
                  final originalCategories = context.read<ProfileCubit>().state.userCategories ?? [];
                  context.read<ProfileCubit>().updateCategoriesOptimistic(
                        tutorId: tutorId,
                        newCategories: _selectedCategories.toList(),
                        originalCategories: originalCategories,
                        context: context,
                      );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Categories (${_selectedCategories.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
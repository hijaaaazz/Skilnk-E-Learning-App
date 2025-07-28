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

  // Initialize selected categories if passed
  _selectedCategories = widget.selectedCategories.toSet();

  // Call getCategories from the bloc
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
              if (state is ProfileCategoriesLoading){
                return Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF5722),
                              ),
                            );
              }else if (state is ProfileCategoriesUpdated){
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
                                      itemCount: state.categoriesLoaded.length,
                                      itemBuilder: (context, index) {
                                        final category = state.categoriesLoaded[index];
                                        final isSelected = _selectedCategories.contains(category);
                                        
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                _selectedCategories.remove(category);
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
              }

              return SizedBox.shrink();
              
            },
          ),

          // Bottom action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
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
  
    _saveCategories(tutorId, _selectedCategories.toList());
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

  void _saveCategories(String userId,List<String> categoryName) {
    context.read<ProfileCubit>().addCategory(
        tutorId:  userId,categories:  categoryName);
    Navigator.pop(context);
  }
}

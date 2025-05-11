import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/domain/usecases/add_category.dart';
import 'package:admin_app/features/courses/domain/usecases/delete_category.dart';
import 'package:admin_app/features/courses/domain/usecases/get_categories.dart';
import 'package:admin_app/features/courses/domain/usecases/update_category.dart';
import 'package:admin_app/features/courses/presentation/bloc/cubit/category_state.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';

class CategoryManagementCubit extends Cubit<CategoryManagementState> {
  CategoryManagementCubit() : super(const CategoriesLoading(categories: []));

  void displayCategories() async {
    emit(CategoriesLoading(categories: state.categories));
    var response = await serviceLocator<GetCategoryUsecase>().call(params:  NoParams());
    response.fold(
      (error) {
        log('Error loading categories: ${error.toString()}');
        emit(CategoriesLoadingError(
          categories: state.categories,
          message: 'Failed to load categories: ${error.toString()}'
        ));
      },
      (data) {
        emit(CategoriesLoadingSuccess(categories: data));
      },
    );
  }

  void updateCategory(CategoryEntity updatedCategory) async {

    final response = await serviceLocator<UpdateCategoryUseCase>().call(params: updatedCategory);
    response.fold(
      (error) {
        log('Error updating category: ${error.toString()}');
        emit(CategoriesUpdationError(
          categories: state.categories,
          message: 'Failed to update category: ${error.toString()}'
        ));
      },
      (data) {
        // Replace updated category in the current list
        final updatedList = state.categories.map((category) {
          return category.id == updatedCategory.id ? updatedCategory : category;
        }).toList();

        emit(CategoriesUpdationSuccess(categories: updatedList));
        
        // Reload categories to ensure we have the latest data
      },
    );
  }

  void createCategory(String title, String description) async {
    
    final newCategory = CategoryEntity(
      id: '', // ID will be assigned by backend
      title: title,
      description: description,
      courses: [],
      isVisible: true
    );
    
    final response = await serviceLocator<AddNewCategoryUsecase>().call(params: newCategory);
    response.fold(
      (error) {
        log('Error creating category: ${error.toString()}');
        
      },
      (createdCategory) {
        final updatedList = List<CategoryEntity>.from(state.categories)..add(createdCategory);
        emit(CategoryCreationSuccess(categories: updatedList));
        
        // Reload categories to ensure we have the latest data
      },
    );
  }

  void deleteCategory(CategoryEntity category) async {
  log(category.id);
  
  if (category.courses.isNotEmpty) {
    emit(CategoryDeletionLoading(
      categories: state.categories,
      message: "Cannot delete category with existing courses",
    ));
    return;
  }

  final response = await serviceLocator<DeleteCategoryuseCase>().call(params: category.id);

  response.fold(
    (error) {
      log('Error deleting category: $error');
      
      emit(CategoryDeletionError(
        categories: state.categories,
        message: 'Failed to delete category: $error'
      ));
    },
    (_) {
      final updatedList = List<CategoryEntity>.from(state.categories)
        ..removeWhere((cat) => cat.id == category.id);
      emit(CategoryDeletionSuccess(categories: updatedList));
    },
  );
}

}
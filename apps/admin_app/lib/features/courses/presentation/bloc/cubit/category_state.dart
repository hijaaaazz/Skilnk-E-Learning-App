import 'package:admin_app/features/courses/domain/entities/category_entity.dart';

abstract class CategoryManagementState {
  final List<CategoryEntity> categories;
  final String? message;

  const CategoryManagementState({
    required this.categories,
    this.message,
  });
  
  @override
  List<Object?> get props => [categories, message];
}

// Loading States
class CategoriesLoading extends CategoryManagementState {
  const CategoriesLoading({required super.categories, super.message});
}

class CategoriesLoadingSuccess extends CategoryManagementState {
  const CategoriesLoadingSuccess({required super.categories, super.message});
}

class CategoriesLoadingError extends CategoryManagementState {
  const CategoriesLoadingError({required super.categories, super.message});
}

// Update States
class CategoriesUpdationLoading extends CategoryManagementState {
  const CategoriesUpdationLoading({required super.categories, super.message});
}

class CategoriesUpdationSuccess extends CategoryManagementState {
  const CategoriesUpdationSuccess({required super.categories, super.message});
}

class CategoriesUpdationError extends CategoryManagementState {
  const CategoriesUpdationError({required super.categories, super.message});
}

// Creation States
class CategoryCreationLoading extends CategoryManagementState {
  const CategoryCreationLoading({required super.categories, super.message});
}

class CategoryCreationSuccess extends CategoryManagementState {
  const CategoryCreationSuccess({required super.categories, super.message});
}

class CategoryCreationError extends CategoryManagementState {
  const CategoryCreationError({required super.categories, super.message});
}







// Creation States
class CategoryDeletionLoading extends CategoryManagementState {
  const CategoryDeletionLoading({required super.categories, super.message});
}

class CategoryDeletionSuccess extends CategoryManagementState {
  const CategoryDeletionSuccess({required super.categories, super.message});
}

class CategoryDeletionError extends CategoryManagementState {
  const CategoryDeletionError({required super.categories, super.message});
}
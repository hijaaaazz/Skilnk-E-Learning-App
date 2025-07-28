import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/account/data/models/delete_category.dart';
import 'package:tutor_app/features/account/data/models/update_bio_params.dart';
import 'package:tutor_app/features/account/data/models/update_category_params.dart';
import 'package:tutor_app/features/account/data/models/update_dp_params.dart';
import 'package:tutor_app/features/account/data/models/update_name_params.dart';
import 'package:tutor_app/features/account/domain/usecase/add_category.dart';
import 'package:tutor_app/features/account/domain/usecase/delete_category.dart';
import 'package:tutor_app/features/account/domain/usecase/get_categories.dart';
import 'package:tutor_app/features/account/domain/usecase/update_bio.dart';
import 'package:tutor_app/features/account/domain/usecase/update_user_profile_pic.dart';
import 'package:tutor_app/features/account/domain/usecase/update_username.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/service_locator.dart';
import 'dart:developer' as developer;

class ProfileCubit extends Cubit<ProfileState> {
  final ImagePicker _imagePicker = ImagePicker();
  final _addCategoryUseCase = serviceLocator<AddCategoryUseCase>();
  final _getCategoriesUseCase = serviceLocator<GetCategoriesUseCase>();
  final _deleteCategoryUseCase = serviceLocator<DeleteCategoryUseCase>();
  final _updateBioUseCase = serviceLocator<UpdateBioUseCase>();
  final _updateNameUseCase = serviceLocator<UpdateNameUserUseCase>();
  final _updateDpUseCase = serviceLocator<UpdateDpUserUseCase>();

  ProfileCubit() : super(const ProfileInitial());

  void loadUserData({
    required String currentName,
    required String currentBio,
    required String currentImageUrl,
    required List<String> userCategories,
  }) {
    developer.log('Loading user data: name=$currentName, bio=$currentBio, image=$currentImageUrl, categories=$userCategories');
    emit(ProfileInitial(
      currentName: currentName,
      currentBio: currentBio,
      currentImageUrl: currentImageUrl,
      userCategories: userCategories,
    ));
  }

  void initializeWithUserData({required String name, required String? imageUrl}) {
    final currentState = state;
    final newImageUrl = currentState is ProfileImageOptimisticUpdate ||
            currentState is ProfileImagePickerLoading ||
            currentState is ProfileImageUpdated ||
            currentState is ProfileImageShowMode
        ? currentState.currentImageUrl
        : imageUrl;
    
    developer.log('Initializing with name: $name, imageUrl: $newImageUrl');
    emit(ProfileInitial(
      currentName: name,
      currentImageUrl: newImageUrl,
      currentBio: currentState.currentBio,
      userCategories: currentState.userCategories,
    ));
  }

  Future<void> loadCategories() async {
    emit(ProfileCategoriesLoading(
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
      userCategories: state.userCategories,
    ));

    final result = await _getCategoriesUseCase.call(params: NoParams());
    result.fold(
      (error) => emit(ProfileError(
        error,
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      )),
      (categories) => emit(ProfileCategoriesUpdated(
        categories.map((e) => e.title).toList(),
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
      )),
    );
  }

  Future<void> updateCategoriesOptimistic({
    required String tutorId,
    required List<String> newCategories,
    required List<String> originalCategories,
    required BuildContext context,
  }) async {
    emit(ProfileCategoriesOptimisticUpdate(
      newCategories,
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
    ));

    emit(ProfileCategoriesLoading(
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
      userCategories: newCategories,
    ));

    final result = await _addCategoryUseCase.call(
      params: UpdateCategoryParams(userId: tutorId, category: newCategories),
    );

    result.fold(
      (error) {
        developer.log('Category update failed: $error');
        emit(ProfileCategoriesUpdateFailed(
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: originalCategories,
        ));
        emit(ProfileError(
          'Failed to update categories: $error',
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: originalCategories,
        ));
      },
      (categories) {
        developer.log('Category update success: $categories');
        if (context.mounted) {
          context.read<AuthBloc>().add(GetCurrentUserEvent());
        }
        emit(ProfileCategoriesUpdated(
          categories,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
        ));
      },
    );
  }

  Future<void> deleteCategory({
    required String tutorId,
    required CategoryModel category,
    required BuildContext context,
  }) async {
    final originalCategories = state.userCategories ?? [];
    final newCategories = [...originalCategories]..remove(category.title);

    emit(ProfileCategoriesOptimisticUpdate(
      newCategories,
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
    ));

    emit(ProfileCategoriesLoading(
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
      userCategories: newCategories,
    ));

    final result = await _deleteCategoryUseCase.call(
      params: DeleteCategoryParams(userId: tutorId, category: category),
    );

    result.fold(
      (error) {
        developer.log('Category deletion failed: $error');
        emit(ProfileCategoriesUpdateFailed(
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: originalCategories,
        ));
        emit(ProfileError(
          'Failed to delete category: $error',
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: originalCategories,
        ));
      },
      (success) {
        developer.log('Category deletion success');
        if (context.mounted) {
          context.read<AuthBloc>().add(GetCurrentUserEvent());
        }
        emit(ProfileCategoriesUpdated(
          newCategories,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
        ));
      },
    );
  }

  Future<void> updateBioOptimistic({
    required String userId,
    required String newBio,
    required String originalBio,
    required BuildContext context,
  }) async {
    if (newBio.trim().isEmpty) {
      emit(ProfileError(
        'Bio cannot be empty',
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
        currentBio: originalBio,
        userCategories: state.userCategories,
      ));
      return;
    }

    emit(ProfileBioOptimisticUpdate(
      newBio.trim(),
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      userCategories: state.userCategories,
    ));

    emit(ProfileBioLoading(
      optimisticBio: newBio.trim(),
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      userCategories: state.userCategories,
    ));

    final result = await _updateBioUseCase.call(
      params: UpdateBioParams(userId: userId, bio: newBio.trim()),
    );

    result.fold(
      (error) {
        developer.log('Bio update failed: $error');
        emit(ProfileBioUpdateFailed(
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: originalBio,
          userCategories: state.userCategories,
        ));
        emit(ProfileError(
          'Failed to update bio: $error',
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: originalBio,
          userCategories: state.userCategories,
        ));
      },
      (bio) {
        developer.log('Bio update success: $bio');
        if (context.mounted) {
          context.read<AuthBloc>().add(GetCurrentUserEvent());
        }
        emit(ProfileBioUpdated(
          bio,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          userCategories: state.userCategories,
        ));
      },
    );
  }

  Future<void> toggleNameEditingMode() async {
    final currentState = state;
    emit(currentState is ProfileNameEditMode
        ? ProfileNameShowMode(
            currentName: currentState.currentName,
            currentImageUrl: currentState.currentImageUrl,
            currentBio: currentState.currentBio,
            userCategories: currentState.userCategories,
          )
        : ProfileNameEditMode(
            currentName: currentState.currentName,
            currentImageUrl: currentState.currentImageUrl,
            currentBio: currentState.currentBio,
            userCategories: currentState.userCategories,
          ));
  }

  Future<void> updateUserNameOptimistic({
    required String userId,
    required String newName,
    required String originalName,
    required BuildContext context,
  }) async {
    if (newName.trim().isEmpty) {
      emit(ProfileError(
        'Name cannot be empty',
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));
      return;
    }

    try {
      emit(ProfileNameOptimisticUpdate(
        newName.trim(),
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));

      emit(ProfileNameEditLoading(
        optimisticName: newName.trim(),
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));

      final result = await _updateNameUseCase.call(
        params: UpdateNameParams(userId: userId, newName: newName.trim()),
      );

      result.fold(
        (error) {
          developer.log('Name update failed: $error');
          emit(ProfileNameUpdateFailed(
            currentName: originalName,
            currentImageUrl: state.currentImageUrl,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
          emit(ProfileError(
            'Failed to update name: $error',
            currentName: originalName,
            currentImageUrl: state.currentImageUrl,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
        },
        (successName) {
          developer.log('Name update success: $successName');
          if (context.mounted) {
            context.read<AuthBloc>().add(GetCurrentUserEvent());
          }
          emit(ProfileNameUpdated(
            successName,
            currentImageUrl: state.currentImageUrl,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
        },
      );
    } catch (e) {
      developer.log('Name update error: $e');
      emit(ProfileNameUpdateFailed(
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));
      emit(ProfileError(
        'Error updating name: $e',
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));
    }
  }

  Future<void> showImagePickerOptimistic({
    required BuildContext context,
    required String userId,
    required ImageSource source,
    String? originalImageUrl,
  }) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) {
        developer.log('No image selected');
        return;
      }

      developer.log('Picked image: name=${pickedFile.name}, path=${pickedFile.path}');

      // Emit optimistic update with the file path (for UI preview)
      emit(ProfileImageOptimisticUpdate(
        kIsWeb ? pickedFile.path : pickedFile.path, // Blob URL on web, file path on mobile
        currentName: state.currentName,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));

      emit(ProfileImagePickerLoading(
        optimisticImageUrl: kIsWeb ? pickedFile.path : pickedFile.path,
        currentName: state.currentName,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));

      final result = await _updateDpUseCase.call(
        params: UpdateDpParams(userId: userId, imagePath: pickedFile), // Pass XFile
      );

      result.fold(
        (error) {
          developer.log('Image upload failed: $error');
          emit(ProfileImageUpdateFailed(
            currentName: state.currentName,
            currentImageUrl: originalImageUrl,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
          emit(ProfileError(
            'Failed to upload image: $error',
            currentName: state.currentName,
            currentImageUrl: originalImageUrl,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
        },
        (imageUrl) {
          developer.log('Image upload success: $imageUrl');
          if (context.mounted) {
            context.read<AuthBloc>().add(GetCurrentUserEvent());
          }
          emit(ProfileImageUpdated(
            imageUrl,
            currentName: state.currentName,
            currentBio: state.currentBio,
            userCategories: state.userCategories,
          ));
        },
      );
    } catch (e) {
      developer.log('Image picker error: $e');
      emit(ProfileImageUpdateFailed(
        currentName: state.currentName,
        currentImageUrl: originalImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));
      emit(ProfileError(
        'Error selecting image: $e',
        currentName: state.currentName,
        currentImageUrl: originalImageUrl,
        currentBio: state.currentBio,
        userCategories: state.userCategories,
      ));
    }
  }
}
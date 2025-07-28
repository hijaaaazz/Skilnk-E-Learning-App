import 'dart:developer';
import 'dart:io';
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

import 'dart:developer' as developer;

import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ImagePicker _imagePicker = ImagePicker();

  ProfileCubit() : super(const ProfileInitial());



void loadUserData({
  required String currentName,
  required String currentBio,
  required String currentImageUrl,
  required List<String> userCategories,
}) {
  log('loadUserData called with: '
      'Name: $currentName, '
      'Bio: $currentBio, '
      'ImageURL: $currentImageUrl, '
      'Categories: $userCategories');

  emit(ProfileInitial(
    userCategories: userCategories,
    currentName: currentName,
    currentBio: currentBio,
    currentImageUrl: currentImageUrl,
  ));
}



  Future<void> loadCategories() async {
    emit(ProfileCategoriesLoading(
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
      currentBio: state.currentBio,
    ));
    final result = await _getCategoriesUseCase.call(params: NoParams());
    result.fold(
      (error) => emit(ProfileError(error,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio)),
      (categories) => emit(ProfileCategoriesUpdated(
        categories.map((e) => e.title).toList(),
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
        currentBio: state.currentBio,
      )),
    );
  }

  /// Add a new category
  Future<void> addCategory({
    required String tutorId,
    required List<String> categories,
  }) async {

    log("uiwehdweyhduyergfyucgryfgwerygfbyrgbfyrfgbyvbft");
    final result = await _addCategoryUseCase.call(
      params: UpdateCategoryParams(userId: tutorId, category: categories),
    );

    result.fold(
      (error) => emit(ProfileError(error,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: state.userCategories)),
      (category) {
        final List<String> updatedList = [...?state.userCategories,...category];
        emit(ProfileCategoriesUpdated(updatedList,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
        ));
      },
    );
  }

  /// Delete a category
  Future<void> deleteCategory({
    required String tutorId,
    required CategoryModel category,
  }) async {
    final result = await _deleteCategoryUseCase.call(
      params: DeleteCategoryParams(userId: tutorId, category: category),
    );

    result.fold(
      (error) => emit(ProfileError(error,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
          userCategories: state.userCategories)),
      (success) {
        final updatedList = [...?state.userCategories]..remove(category.title);
        emit(ProfileCategoriesUpdated(updatedList,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          currentBio: state.currentBio,
        ));
      },
    );
  }

  /// Update bio
  Future<void> updateBio({
    required String userId,
    required String newBio,
  }) async {
    final result = await _updateBioUseCase.call(
      params: UpdateBioParams(userId: userId, bio: newBio),
    );

    result.fold(
      (error) => emit(ProfileError(error,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          userCategories: state.userCategories,
          currentBio: state.currentBio)),
      (bio) => emit(ProfileBioUpdated(bio,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
          userCategories: state.userCategories)),
    );
  }

  final _addCategoryUseCase = serviceLocator<AddCategoryUseCase>();
  final _getCategoriesUseCase = serviceLocator<GetCategoriesUseCase>();
  final _deleteCategoryUseCase = serviceLocator<DeleteCategoryUseCase>();
  final _updateBioUseCase = serviceLocator<UpdateBioUseCase>();

  /// Toggle between name show and edit modes
  Future<void> toggleNameEditingMode() async {
    if (state is ProfileNameEditMode) {
      emit(ProfileNameShowMode(
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
      ));
    } else {
      emit(ProfileNameEditMode(
        currentName: state.currentName,
        currentImageUrl: state.currentImageUrl,
      ));
    }
  }

  /// Update username with optimistic UI
  void updateUserNameOptimistic({
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
      ));
      return;
    }

    try {
      developer.log('Emitting ProfileNameOptimisticUpdate with name: $newName');
      emit(ProfileNameOptimisticUpdate(
        newName,
        currentImageUrl: state.currentImageUrl,
      ));

      developer.log('Emitting ProfileNameEditLoading with name: $newName');
      emit(ProfileNameEditLoading(
        optimisticName: newName,
        currentImageUrl: state.currentImageUrl,
      ));

      final updateName = serviceLocator<UpdateNameUserUseCase>();
      final result = await updateName.call(
        params: UpdateNameParams(userId: userId, newName: newName.trim()),
      );

      result.fold(
        (error) {
          developer.log('Name update failed: $error');
          emit(ProfileNameUpdateFailed(
            currentName: originalName,
            currentImageUrl: state.currentImageUrl,
          ));
          emit(ProfileNameShowMode(
            currentName: originalName,
            currentImageUrl: state.currentImageUrl,
          ));
          emit(ProfileError(
            'Failed to update name: $error',
            currentName: originalName,
            currentImageUrl: state.currentImageUrl,
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
          ));
          emit(ProfileNameShowMode(
            currentName: successName,
            currentImageUrl: state.currentImageUrl,
          ));
        },
      );
    } catch (e) {
      developer.log('Name update error: $e');
      emit(ProfileNameUpdateFailed(
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
      ));
      emit(ProfileNameShowMode(
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
      ));
      emit(ProfileError(
        'Error updating name: $e',
        currentName: originalName,
        currentImageUrl: state.currentImageUrl,
      ));
    }
  }

  void showImagePickerOptimistic({
  required BuildContext context,
  required String userId,
  required ImageSource source,
  String? originalImageUrl,
}) async {
  try {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final localImagePath = pickedFile.path;
      developer.log('Emitting ProfileImageOptimisticUpdate with path: $localImagePath');
      emit(ProfileImageOptimisticUpdate(
        localImagePath,
        currentName: state.currentName,
      ));

      developer.log('Emitting ProfileImagePickerLoading with path: $localImagePath');
      emit(ProfileImagePickerLoading(
        optimisticImageUrl: localImagePath,
        currentName: state.currentName,
      ));

      final updateDp = serviceLocator<UpdateDpUserUseCase>();
      final result = await updateDp.call(
        params: UpdateDpParams(userId: userId, imagePath: pickedFile.path),
      );

      result.fold(
        (error) {
          developer.log('Image upload failed: $error');
          emit(ProfileImageUpdateFailed(
            currentName: state.currentName,
            currentImageUrl: originalImageUrl,
          ));
          emit(ProfileError(
            'Failed to upload image: $error',
            currentName: state.currentName,
            currentImageUrl: originalImageUrl,
          ));
        },
        (imageUrl) {
          developer.log('Image upload success, emitting ProfileImageUpdated with URL: $imageUrl');
          if (context.mounted) {
            // context.read<AuthBloc>().updateUserDp(imageUrl);
            // context.read<AuthBloc>().getCurrentUser();
          }
          emit(ProfileImageUpdated(
            imageUrl,
            currentName: state.currentName,
          ));
          developer.log('Emitting ProfileImageShowMode with URL: $imageUrl');
          emit(ProfileImageShowMode(
            currentName: state.currentName,
            currentImageUrl: imageUrl,
          ));
        },
      );
    }
  } catch (e) {
    developer.log('Image picker error: $e');
    emit(ProfileImageUpdateFailed(
      currentName: state.currentName,
      currentImageUrl: originalImageUrl,
    ));
    emit(ProfileError(
      'Error selecting image: $e',
      currentName: state.currentName,
      currentImageUrl: originalImageUrl,
    ));
  }
}

 
  /// Initialize cubit with user data
  void initializeWithUserData({required String name, required String? imageUrl}) {
    String? newImageUrl = imageUrl;
    if (state is ProfileImageOptimisticUpdate ||
        state is ProfileImagePickerLoading ||
        state is ProfileImageUpdated ||
        state is ProfileImageShowMode) {
      newImageUrl = state.currentImageUrl;
    }
    developer.log('Initializing with name: $name, imageUrl: $newImageUrl');
    emit(ProfileInitial(
      currentName: name,
      currentImageUrl: newImageUrl,
    ));
  }
}
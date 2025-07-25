import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import  'package:user_app/features/account/data/models/update_dp_params.dart';
import  'package:user_app/features/account/data/models/update_name_params.dart';
import  'package:user_app/features/account/domain/usecase/get_recent_activities.dart';
import  'package:user_app/features/account/domain/usecase/update_user_profile_pic.dart';
import  'package:user_app/features/account/domain/usecase/update_username.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_state.dart';
import  'package:user_app/service_locator.dart';
import 'dart:developer' as developer;

class ProfileCubit extends Cubit<ProfileState> {
  final ImagePicker _imagePicker = ImagePicker();

  ProfileCubit() : super(const ProfileInitial());

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
            context.read<AuthStatusCubit>().getCurrentUser();
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
            context.read<AuthStatusCubit>().updateUserDp(imageUrl);
            context.read<AuthStatusCubit>().getCurrentUser();
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
Future<void> fetchRecentActivities({required String userId}) async {
  try {
    emit(ProfileActivitiesLoading(
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
    ));


    final result = await serviceLocator<GetRecentActivitiesUseCase>().call(params: userId);

    result.fold(
      (failureMessage) {
        emit(ProfileError(
          failureMessage,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
        ));
      },
      (activitiesList) {
        emit(ProfileActivitiesLoaded(
          activitiesList,
          currentName: state.currentName,
          currentImageUrl: state.currentImageUrl,
        ));
      },
    );
  } catch (e) {
    emit(ProfileError(
      'Failed to fetch activities: $e',
      currentName: state.currentName,
      currentImageUrl: state.currentImageUrl,
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
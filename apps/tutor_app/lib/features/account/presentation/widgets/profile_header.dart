import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_cubit.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_state.dart';
import 'package:tutor_app/features/account/presentation/widgets/bottom_sheet.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';
import 'dart:developer' as developer;

class ProfileHeader extends StatefulWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late TextEditingController _nameController;
  static const int maxNameLength = 25;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    context.read<ProfileCubit>().initializeWithUserData(
          name: widget.user.name,
          imageUrl: widget.user.image,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    if (_nameController.text.trim().isNotEmpty &&
        _nameController.text.trim().length <= maxNameLength) {
      context.read<ProfileCubit>().updateUserNameOptimistic(
            userId: widget.user.tutorId,
            newName: _nameController.text.trim(),
            originalName: widget.user.name,
            context: context,
          );
    }
  }

  void _toggleEditMode() {
    context.read<ProfileCubit>().toggleNameEditingMode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              developer.log('Building profile image for state: ${profileState.runtimeType}');
              return GestureDetector(
                onTap: () {
                  ImagePickerBottomSheet.show(context, userId: widget.user.tutorId);
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: _buildProfileImage(profileState),
                      ),
                    ),
                    if (profileState is ProfileImagePickerLoading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              String currentName = profileState.currentName ?? widget.user.name;

              if (profileState is ProfileNameUpdated &&
                  _nameController.text != profileState.name) {
                _nameController.text = profileState.name;
              }

              if (profileState is ProfileNameShowMode ||
                  profileState is ProfileInitial ||
                  profileState is ProfileNameUpdated ||
                  profileState is ProfileNameOptimisticUpdate) {
                return GestureDetector(
                  onTap: _toggleEditMode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          currentName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ],
                  ),
                );
              } else if (profileState is ProfileNameEditMode) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 250,
                        ),
                        child: TextField(
                          controller: _nameController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          maxLength: maxNameLength,
                          maxLines: 1,
                          onSubmitted: (_) => _saveName(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black87),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            counterText: '',
                          ),
                          cursorColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _saveName,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _nameController.text = currentName;
                        _toggleEditMode();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[700],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (profileState is ProfileNameEditLoading) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        currentName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.black54,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: _toggleEditMode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          currentName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.user.email,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ProfileState profileState) {
    String? imageUrl;

    if (profileState is ProfileImageOptimisticUpdate) {
      imageUrl = profileState.optimisticImageUrl;
    } else if (profileState is ProfileImagePickerLoading) {
      imageUrl = profileState.optimisticImageUrl;
    } else if (profileState is ProfileImageUpdated) {
      imageUrl = profileState.imageUrl;
    } else if (profileState is ProfileImageShowMode) {
      imageUrl = profileState.currentImageUrl;
    } else if (profileState is ProfileImageUpdateFailed) {
      imageUrl = profileState.currentImageUrl ?? widget.user.image;
    } else {
      imageUrl = profileState.currentImageUrl ?? widget.user.image;
    }

    developer.log('Selected imageUrl: $imageUrl for state: ${profileState.runtimeType}');
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.black54,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[100],
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        );
      } else {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[100],
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        );
      }
    }

    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_state.dart';
import  'package:user_app/features/account/presentation/widgets/bottom_sheet.dart';
import  'package:user_app/features/auth/domain/entity/user.dart';
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
            userId: widget.user.userId,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade600],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        child: Column(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
                developer.log('Building profile image for state: ${profileState.runtimeType}');
                return GestureDetector(
                  onTap: () {
                    ImagePickerBottomSheet.show(context, userId: widget.user.userId);
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.deepOrange.shade800, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.deepOrange.shade800,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              currentName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ],
                    ),
                  );
                } else if (profileState is ProfileNameEditMode) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 100,
                              maxWidth: 300,
                            ),
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _nameController,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                maxLength: maxNameLength,
                                maxLines: 1,
                                onSubmitted: (_) => _saveName(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  counterText: '',
                                ),
                                cursorColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _saveName,
                        child: Icon(
                          Icons.check,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _nameController.text = currentName;
                          _toggleEditMode();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ],
                  );
                } else if (profileState is ProfileNameEditLoading) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            currentName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              currentName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          color: Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(ProfileState profileState) {
    String? imageUrl;

    // Handle each state explicitly
    if (profileState is ProfileImageOptimisticUpdate) {
      imageUrl = profileState.optimisticImageUrl; // Local file path
    } else if (profileState is ProfileImagePickerLoading) {
      imageUrl = profileState.optimisticImageUrl; // Local file path during upload
    } else if (profileState is ProfileImageUpdated) {
      imageUrl = profileState.imageUrl; // Server URL after successful upload
    } else if (profileState is ProfileImageShowMode) {
      imageUrl = profileState.currentImageUrl; // Persist updated image
    } else if (profileState is ProfileImageUpdateFailed) {
      imageUrl = profileState.currentImageUrl ?? widget.user.image; // Revert to previous or user image
    } else if (profileState is ProfileNameOptimisticUpdate ||
               profileState is ProfileNameEditLoading ||
               profileState is ProfileNameUpdated ||
               profileState is ProfileNameUpdateFailed ||
               profileState is ProfileNameEditMode ||
               profileState is ProfileNameShowMode ||
               profileState is ProfileInitial ||
               profileState is ProfileActivitiesLoading ||
               profileState is ProfileActivitiesLoaded ||
               profileState is ProfileError) {
      imageUrl = profileState.currentImageUrl ?? widget.user.image; // Use current or user image
    }

    developer.log('Selected imageUrl: $imageUrl for state: ${profileState.runtimeType}');
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(
            color: Colors.deepOrange,
          ),
          errorWidget: (context, url, error) => const Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        );
      } else {
        return Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        );
      }
    }

    return const Icon(
      Icons.person,
      size: 60,
      color: Colors.white,
    );
  }
}
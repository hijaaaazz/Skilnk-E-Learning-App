import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/features/account/presentation/bloc/cubit/profile_cubit.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final String userId;

  const ImagePickerBottomSheet({super.key, required this.userId});

  static void show(BuildContext context, {required String userId}) {
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: ImagePickerBottomSheet(userId: userId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Update Profile Picture',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImagePickerOption(
                context,
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: () {
                  context.read<ProfileCubit>().showImagePickerOptimistic(
                        source: ImageSource.gallery,
                        userId: userId,
                        context: context,
                        originalImageUrl: context.read<ProfileCubit>().state.currentImageUrl,
                      );
                },
              ),
              _buildImagePickerOption(
                context,
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                onTap: () {
                  context.read<ProfileCubit>().showImagePickerOptimistic(
                        source: ImageSource.camera,
                        userId: userId,
                        context: context,
                        originalImageUrl: context.read<ProfileCubit>().state.currentImageUrl,
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import  'package:user_app/features/account/presentation/blocs/cubit/profile_cubit.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final String userId;

  const ImagePickerBottomSheet({super.key, required this.userId});

  static void show(BuildContext context, {required String userId}) {
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Update Profile Picture',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImagePickerOption(
                context,
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  context.read<ProfileCubit>().showImagePickerOptimistic(
                        source: ImageSource.gallery,
                        userId: userId,
                        context: context, // bottomSheetContext
                        originalImageUrl: context.read<ProfileCubit>().state.currentImageUrl,
                      );
                },
              ),
              _buildImagePickerOption(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  context.read<ProfileCubit>().showImagePickerOptimistic(
                        source: ImageSource.camera,
                        userId: userId,
                        context: context, // bottomSheetContext
                        originalImageUrl: context.read<ProfileCubit>().state.currentImageUrl,
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Use bottomSheetContext
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, size: 30, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
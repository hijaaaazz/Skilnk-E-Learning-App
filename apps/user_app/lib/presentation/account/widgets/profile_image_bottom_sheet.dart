import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import  'package:user_app/features/account/presentation/widgets/image_options.dart';

void showProfileImageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2.5)),
              ),
              Text(
                'Update Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade800),
              ),
              const SizedBox(height: 20),
              ImageOptionItem(
                icon: Icons.photo_library_outlined,
                label: 'Choose from Gallery',
                onTap: () => selectImage(context, ImageSource.gallery),
              ),
              ImageOptionItem(
                icon: Icons.camera_alt_outlined,
                label: 'Take a Photo',
                onTap: () => selectImage(context, ImageSource.camera),
              ),
              ImageOptionItem(
                icon: Icons.delete_outline,
                label: 'Remove Current Photo',
                iconColor: Colors.red.shade700,
                textColor: Colors.red.shade700,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

void selectImage(BuildContext context, ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);
  Navigator.pop(context);
  if (image != null) {
    // Implement upload logic
  }
}

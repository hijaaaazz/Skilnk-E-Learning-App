import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import  'package:user_app/features/auth/presentation/widgets%20/auth_input_fieds.dart';

class InfoSubmitionPage extends StatefulWidget {
  const InfoSubmitionPage({super.key});

  @override
  State<InfoSubmitionPage> createState() => _InfoSubmitionPageState();
}

class _InfoSubmitionPageState extends State<InfoSubmitionPage> {
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final tutorIdController = TextEditingController();
  final coursesController = TextEditingController();

  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _submitDetails() {
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Additional Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile image picker
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Phone field
            AuthInputField(            

              controller: phoneController,
              hintText: "Phone Number",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.length < 10
                  ? 'Enter valid phone number'
                  : null,
            ),
            const SizedBox(height: 10),

            // Bio
            AuthInputField(
              controller: bioController,
              hintText: "Bio",
              icon: Icons.info_outline,
              validator: (value) => null,
            ),
            const SizedBox(height: 10),

            // Tutor ID
            AuthInputField(
              controller: tutorIdController,
              hintText: "Tutor ID",
              icon: Icons.badge,
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter tutor ID" : null,
            ),
            const SizedBox(height: 10),

            // Courses
            AuthInputField(
              controller: coursesController,
              hintText: "Course IDs (comma separated)",
              icon: Icons.book,
              validator: (value) => null,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitDetails,
              child: const Text("Submit Details"),
            ),
          ],
        ),
      ),
    );
  }
}

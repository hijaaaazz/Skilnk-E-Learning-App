import 'package:flutter/material.dart';

class StepBasicInfo extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String selectedCategory;
  final Function(String) onCategoryChanged;
  final Function(String) onThumbnailChanged;

  const StepBasicInfo({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onThumbnailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Course Title'),
        TextFormField(
          controller: titleController,
          validator: (val) =>
              val == null || val.isEmpty ? 'Enter course title' : null,
        ),
        const SizedBox(height: 12),
        const Text('Description'),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          validator: (val) =>
              val == null || val.isEmpty ? 'Enter description' : null,
        ),
        const SizedBox(height: 12),
        const Text('Category'),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items: ['Programming', 'Design', 'Marketing']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => onCategoryChanged(val!),
        ),
        const SizedBox(height: 12),
        const Text('Thumbnail URL'),
        TextFormField(
          onChanged: onThumbnailChanged,
        ),
      ],
    );
  }
}

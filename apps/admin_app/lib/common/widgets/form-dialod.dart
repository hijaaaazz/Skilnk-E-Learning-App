import 'package:flutter/material.dart';

class FormDialog {
  static void show({
    required BuildContext context,
    required String title,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required VoidCallback onDone,
    bool showCancelButton = true,
    String cancelText = 'Cancel',
    String doneText = 'Done',
    Color titleColor = Colors.deepOrange,
    Color backgroundColor = Colors.white,
    Color doneButtonColor = Colors.deepOrange,
    Color cancelButtonColor = Colors.white,
    Color doneTextColor = Colors.white,
    Color cancelTextColor = Colors.deepOrange,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            if (showCancelButton)
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: cancelTextColor,
                  backgroundColor: cancelButtonColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(cancelText),
              ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: doneTextColor,
                backgroundColor: doneButtonColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDone();
              },
              child: Text(doneText),
            ),
          ],
        );
      },
    );
  }
}

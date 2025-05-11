import 'package:flutter/material.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required String title,
    Widget? content,
    String cancelText = 'Cancel',
    String doneText = 'Done',
    VoidCallback? onCancel,
    VoidCallback? onDone,
    bool showCancelButton = true,
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
          content: content, // Can be any widget or null
          actions: [
            if (showCancelButton)
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: cancelTextColor,
                  backgroundColor: cancelButtonColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel?.call();
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
                onDone?.call();
              },
              child: Text(doneText),
            ),
          ],
        );
      },
    );
  }
}

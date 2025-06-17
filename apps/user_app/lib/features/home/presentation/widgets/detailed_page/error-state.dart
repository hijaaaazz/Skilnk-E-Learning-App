// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text('Error: $errorMessage', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
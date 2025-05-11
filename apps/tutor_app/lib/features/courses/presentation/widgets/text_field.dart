import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final int? maxLength;
  final bool showCounter;
  final String? errorText;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final IconData? suffixIcon;
  final Color primaryColor;
  final double borderRadius;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.maxLength,
    this.showCounter = false,
    this.errorText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.suffixIcon,
    this.primaryColor = Colors.deepOrange,
    this.borderRadius = 8.0,
    this.textInputAction,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            counterText: showCounter ? null : '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            errorStyle: TextStyle(
              color: Colors.red[700],
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.red[700]!, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.red[700]!, width: 2),
            ),
            suffixIcon: Icon(suffixIcon,color: Colors.grey,size: 15)
            
          ),
          maxLength: maxLength,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: obscureText,
          textInputAction: textInputAction,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
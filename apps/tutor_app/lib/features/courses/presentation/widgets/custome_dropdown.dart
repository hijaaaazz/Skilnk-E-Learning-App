import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/presentation/widgets/text_field.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? errorText;
  final Color primaryColor;
  final double borderRadius;
  final bool isSearchable;
  final Widget? prefixIcon;

  const AppDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
    this.primaryColor = Colors.deepOrange,
    this.borderRadius = 8.0,
    this.isSearchable = false,
    this.prefixIcon,
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
        DropdownButtonFormField<T>(
          value: value,
          
          hint: Text(
            hint,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),

          selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((DropdownMenuItem<T> item) {
          return Text(
            item.child is Text ? (item.child as Text).data ?? '' : item.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          );
        }).toList();
      },

          decoration: InputDecoration(
            
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon,
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
          ),
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          iconSize: 24,
          dropdownColor: Colors.white,
          
          style: const TextStyle(
            
            fontSize: 14,
            color: Colors.black87,
          ),
          // Customizing the dropdown button appearance
          menuMaxHeight: 300,
          itemHeight: 48,
          // Add some visual feedback on hover
          onTap: () {},
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

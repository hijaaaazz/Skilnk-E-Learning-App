import 'package:flutter/material.dart';

class StepAdvancedInfo extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController discountController;
  final String selectedLevel;
  final Function(String) onLevelChanged;

  const StepAdvancedInfo({
    super.key,
    required this.priceController,
    required this.discountController,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Price'),
        TextFormField(
          controller: priceController,
          keyboardType: TextInputType.number,
          validator: (val) =>
              val == null || val.isEmpty ? 'Enter price' : null,
        ),
        const SizedBox(height: 12),
        const Text('Discount (%)'),
        TextFormField(
          controller: discountController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        const Text('Level'),
        DropdownButtonFormField<String>(
          value: selectedLevel,
          items: ['Beginner', 'Intermediate', 'Advanced']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => onLevelChanged(val!),
        ),
      ],
    );
  }
}

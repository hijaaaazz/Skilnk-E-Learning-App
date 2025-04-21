import 'package:flutter/material.dart';

class ImageOptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const ImageOptionItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor = Colors.deepOrange,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
      ),
    );
  }
}

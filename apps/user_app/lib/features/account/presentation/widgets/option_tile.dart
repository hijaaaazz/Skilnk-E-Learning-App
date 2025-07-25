import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

Widget buildOptionTile(
  BuildContext context,
  String title,
  IconData icon, {
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildDivider() {
  return Divider(
    height: 1,
    thickness: 0.5,
    color: Colors.grey.shade200,
  );
}

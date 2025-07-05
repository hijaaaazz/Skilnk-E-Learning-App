import 'package:flutter/material.dart';
import  'package:user_app/features/explore/presentation/theme.dart';

class SkilnkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const SkilnkAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: AppBar(
        
        foregroundColor: Colors.black,
        title: Text(
          title, // Use the provided title here
          style: TextStyle(
            color: ExploreTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: actions,
        backgroundColor: ExploreTheme.backgroundColor,
        elevation: 0,
      ),
    );
  }

  // Required when using a custom AppBar in Scaffold
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

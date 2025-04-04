import 'package:admin_app/common/bloc/cubit/button_cubit.dart';
import 'package:admin_app/common/bloc/cubit/button_state.dart';
import 'package:admin_app/common/widgets/app_text.dart';
import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasicReactiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? content;

  const BasicReactiveButton({
    required this.onPressed,
    this.title = 'Sign In',
    this.height,
    this.backgroundColor,
    this.textColor,
    this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoadingState) {
          return _loading(context);
        }
        return _initial(context);
      },
    );
  }

  Widget _loading(BuildContext context) {
    return ElevatedButton(
      onPressed: null, // Disabled when loading
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
      ),
    );
  }

  Widget _initial(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? context.customColors.primaryOrange,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: content ??
          AppText(
            text: title,
            color: textColor ?? context.customColors.textWhite,
            weight: FontWeight.bold,
          ),
    );
  }
}

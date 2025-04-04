import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/cubit/button_cubit.dart';
import 'package:user_app/common/bloc/cubit/button_state.dart';
import 'package:user_app/common/widgets/app_text.dart';

class BasicReactiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? content;

  const BasicReactiveButton({
    required this.onPressed,
    this.title = 'Same',
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
          return _loading();
        }
        return _initial(context);
      },
    );
  }

  Widget _loading() {
    return Container(
      height: height ?? 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _initial(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 50,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: backgroundColor?? const Color.fromARGB(255, 221, 221, 221),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: content ??
            AppText(
              text: title,
              color: textColor ?? Colors.white,
              weight: FontWeight.bold,
            ),
      ),
    );
  }
}

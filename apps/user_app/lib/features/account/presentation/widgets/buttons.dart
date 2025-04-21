import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_state.dart';

class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;

  const PrimaryAuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        final isLoading = state is ButtonLoadingState;

        return SizedBox(
          width: width,
          height: 50,
          child: Stack(
            children: [
              ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade800,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.deepOrange.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomPaint(
                      painter: GradientProgressPainter(
                        progress: 1.0, // You can add animation if you want
                        baseColor: Colors.deepOrange.shade800,
                        progressColor: Colors.deepOrange.shade400,
                      ),
                    ),
                  ),
                ),
              if (isLoading)
                Positioned.fill(
                  child: Center(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}


class GradientProgressPainter extends CustomPainter {
  final double progress; // Value between 0.0 and 1.0
  final Color baseColor;
  final Color progressColor;

  GradientProgressPainter({
    required this.progress,
    required this.baseColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [progressColor, baseColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    final rect = Rect.fromLTWH(0, 0, size.width * progress, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(15));

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.baseColor != baseColor ||
           oldDelegate.progressColor != progressColor;
  }
}



// Google Sign In Button
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final double width;

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.deepOrange.shade400,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.deepOrange.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

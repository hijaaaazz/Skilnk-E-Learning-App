import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:admin_app/features/auth/presentaion/widgets/auth_form.dart';
import 'package:admin_app/features/auth/presentaion/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(
  builder: (context, constraints) {
    final double aspectRatio = constraints.maxWidth / constraints.maxHeight;

    // Define breakpoints based on aspect ratio
    if (aspectRatio > 1.5) {
      // Wide screens (Desktops)
      return _buildDesktopLayout(context, constraints);
    } else {
      // Narrow screens (Mobiles)
      return _buildMobileLayout(context, constraints);
    }
  },
);

  }
  
  Widget _buildDesktopLayout(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: context.customColors.backgroundLightBlue,
            height: constraints.maxHeight,
            width: constraints.maxWidth * 0.45,
            child: const Image(
              image: AssetImage("assets/images/sally_illustration.png"),
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: context.customColors.primaryWhite,
              child: const Center(
                child: LoginForm(),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _buildMobileLayout(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: context.customColors.backgroundLightBlue,
                height: constraints.maxHeight * 0.3,
                width: constraints.maxWidth,
                child: const Image(
                  image: AssetImage("assets/images/sally_illustration.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                color: context.customColors.primaryWhite,
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight * 0.7,
                ),
                width: constraints.maxWidth,
                child: const Center(
                  child: LoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

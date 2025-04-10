import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  final bool isDesktop;
  
  const NavBar({super.key, this.isDesktop = true});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth > 768 ? 80 : 60,
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.05,
          ),
          decoration: const BoxDecoration(color: Colors.white),
          child: isDesktop 
              ? _buildDesktopNavBar(context, constraints)
              : _buildMobileNavBar(context, constraints),
        );
      }
    );
  }
  
  Widget _buildDesktopNavBar(BuildContext context, BoxConstraints constraints) {
    final logoFontSize = constraints.maxWidth > 1200 ? 40.0 : 32.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Image(image: AssetImage("assets/images/hand_shake.png")),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Skil',
                    style: GoogleFonts.outfit(
                      color: context.customColors.textBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: logoFontSize,
                      letterSpacing: -0.96,
                    ),
                  ),
                  TextSpan(
                    text: 'nk',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFFF6636),
                      fontWeight: FontWeight.bold,
                      height: 1.24,
                      fontSize: logoFontSize,
                      letterSpacing: -0.96,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Don\'t have account?',
              style: TextStyle(
                color: const Color(0xFF4D5565),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.57,
                letterSpacing: -0.14,
              ),
            ),
            SizedBox(width: constraints.maxWidth * 0.01),
            TextButton(
              onPressed: (){},
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: const Color(0xFFFF6636),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 3,
                  letterSpacing: -0.13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMobileNavBar(BuildContext context, BoxConstraints constraints) {
    final logoFontSize = 24.0;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              height: 40,
              child: Image(
                image: AssetImage("assets/images/hand_shake.png"),
                fit: BoxFit.contain,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Skil',
                    style: GoogleFonts.outfit(
                      color: context.customColors.textBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: logoFontSize,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'nk',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFFF6636),
                      fontWeight: FontWeight.bold,
                      height: 1.24,
                      fontSize: logoFontSize,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: (){},
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: const Color(0xFFFF6636),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}


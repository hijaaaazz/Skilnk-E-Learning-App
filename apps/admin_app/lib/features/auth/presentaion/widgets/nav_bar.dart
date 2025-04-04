import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.1,
     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(image: AssetImage("assets/images/hand_shake.png")),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Skil',
                      style: GoogleFonts.outfit(
                        color: context.customColors.textBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        letterSpacing: -0.96,
                      ),
                    ),
                    TextSpan(
                      text: 'nk',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFF6636),
                        fontWeight: FontWeight.bold,
                        height: 1.24,
                        fontSize: 40,
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
                'Don’t have account?',
                style: TextStyle(
                  color: const Color(0xFF4D5565),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.57,
                  letterSpacing: -0.14,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              TextButton(
                onPressed: (){

                },
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
      ),
    );
  }
}

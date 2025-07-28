// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_text.dart';

class WebWelcomeSection extends StatelessWidget {
  final bool isInitialMode;

  const WebWelcomeSection({
    super.key,
    required this.isInitialMode,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    
    return AnimatedOpacity(
      opacity: isInitialMode ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.height * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "HELLO",
              size: screenSize.width * 0.08, // Responsive font size
              weight: FontWeight.bold,
              color: Colors.white,
            ),
            SizedBox(height: screenSize.height * 0.02),
            Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width * 0.35,
              ),
              child: AppText(
                textAlign: TextAlign.left,
                text: "Welcome! Sign in or create an account to continue your learning journey.",
                size: screenSize.width * 0.018,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: screenSize.height * 0.04),
            
            // Additional decorative elements
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              width: isInitialMode ? screenSize.width * 0.2 : screenSize.width * 0.1,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

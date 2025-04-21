import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_text.dart';

// ignore: must_be_immutable
class AnimatedWelcomeText extends StatelessWidget {
  bool isInitialMode;
   AnimatedWelcomeText({super.key, required this.isInitialMode});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size ;
    return AnimatedOpacity(
                  opacity: isInitialMode ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: screenSize.height * 0.1
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "HELLO",
                            size: 70,
                            weight: FontWeight.bold,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                            child: AppText(
                              textAlign: TextAlign.left,
                              text: "Welcome! Sign in or create an account to continue.",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
  }
}
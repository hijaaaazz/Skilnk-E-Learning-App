import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import  'package:user_app/features/auth/presentation/widgets%20/animated_widgets/slanded_clipper.dart';

// ignore: must_be_immutable
class AnimatedBackgroundContainer extends StatelessWidget {
  bool isInitialMode;
   AnimatedBackgroundContainer({super.key,required this.isInitialMode});

  @override
  Widget build(BuildContext context,) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          bottom: 0,
          left: 0,
          right: 0,
          height: context.watch<AuthUiCubit>().state.formType == AuthFormType.initial
              ? screenHeight * 0.5
              : screenHeight * 0.75,
          child: AnimatedSlantedClipper(isSlanted: !isInitialMode, screenHeight: screenHeight),
        ),


        
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          top: isInitialMode ? screenHeight * 0.45 : screenHeight * 0.15,
          left: 10,
          child: SizedBox(
            width: screenWidth * 0.6,
            height: screenHeight * 0.12,
            child: const Image(
              image: AssetImage("assets/images/handshake.png")
            )
          ),
        ),
      ],
    );
  }
}
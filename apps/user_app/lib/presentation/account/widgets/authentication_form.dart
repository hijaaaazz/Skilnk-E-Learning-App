import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/common/widgets/app_text.dart';
import  'package:user_app/presentation/account/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import  'package:user_app/presentation/account/widgets/auth_buttons.dart';
import  'package:user_app/presentation/account/widgets/signin_section.dart';
import  'package:user_app/presentation/account/widgets/signup_section.dart';

class AuthForm extends StatelessWidget {
  final bool isInitialMode;
  final bool isSignIn;

  const AuthForm({super.key, required this.isInitialMode, this.isSignIn = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: isInitialMode
              ? const AuthButtonsContainer()
              : (isSignIn ? const SignInForm() : const SignUpForm()),
        ),
      ],
    );
  }
}

class AuthButtonsContainer extends StatelessWidget {
  const AuthButtonsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AuthButtons(
          text: "Sign In",
          backgroundColor: const Color.fromARGB(255, 139, 33, 0),
          color: Colors.white,
          onPressed: () {
            context.read<AuthUiCubit>().toggleAuthMode(true);
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        AuthButtons(
          text: "Sign Up",
          backgroundColor: Colors.white,
          color: const Color.fromARGB(255, 139, 33, 0),
          onPressed: () {
            context.read<AuthUiCubit>().toggleAuthMode(false);
          },
        )
      ],
    );
  }
}



class AuthFormContainer extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final String buttonText;
  final VoidCallback onPressed;
  final String switchText;
  final VoidCallback onSwitchPressed;
  final bool isSignIn;

  const AuthFormContainer({
    super.key,
    required this.title,
    required this.fields,
    required this.buttonText,
    required this.onPressed,
    required this.switchText,
    required this.onSwitchPressed,
    required this.isSignIn
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 139, 33, 0),
            ),
          ),
          const SizedBox(height: 20),
          ...fields,
          const SizedBox(height: 30),
          AuthButtons(
            text: buttonText,
            backgroundColor: const Color.fromARGB(255, 139, 33, 0),
            color: Colors.white,
            onPressed: onPressed,
          ),
          const SizedBox(height: 15),
          if(isSignIn)
            TextButton(
            onPressed: (){

            },
            child: Text(
              "Forgot Password ?",
              style: const TextStyle(
                color: Color.fromARGB(255, 139, 33, 0),
              ),
            ),
          ),
           TextButton(
            
            onPressed: (){
              log('ujfuyhbcfgyvbrdgtfcvberdygbcfgyrbfcyugbdyfcg');
            },
             child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SizedBox(
                      height: MediaQuery.of(context).size.height *0.04,
                       child: Image(
                        image: AssetImage("assets/images/google.png")),
                     ),
                     AppText(text: title)
                   ],
                 ),
           ),
          TextButton(
            onPressed: onSwitchPressed,
            child: Text(
              switchText,
              style: const TextStyle(
                color: Color.fromARGB(255, 139, 33, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:user_app/common/widgets/basic_reactive_button.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/widgets/buttons.dart';
import 'package:user_app/features/auth/presentation/widgets%20/forgot_password_dialog.dart';
import 'package:user_app/features/auth/presentation/widgets%20/signin_section.dart';
import 'package:user_app/features/auth/presentation/widgets%20/signup_section.dart';

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
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocProvider(
            create: (_)=> ButtonStateCubit(),
            child: BasicReactiveButton(
              title: "Sign In",
              backgroundColor: const Color.fromARGB(255, 194, 45, 0),
              onPressed: (){
              context.read<AuthUiCubit>().switchToForm(AuthFormType.signIn);
            } ),
          ),
         
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
      
          BlocProvider(
            create: (_) => ButtonStateCubit(),
            child: BasicReactiveButton(
              title: "Sign Up",
              textColor: const Color.fromARGB(255, 194, 45, 0),
              backgroundColor: Colors.white,
              onPressed: (){
              context.read<AuthUiCubit>().switchToForm(AuthFormType.signUp);
            }),
          )
         
        ],
      ),
    );
  }
}

class AuthFormContainer extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final String switchText;
  final VoidCallback onSwitchPressed;
  final bool isSignIn;

  const AuthFormContainer({
    super.key,
    required this.title,
    required this.fields,
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
          
          const SizedBox(height: 15),
          if(isSignIn)
            TextButton(
              onPressed: () {
                context.read<AuthUiCubit>().switchToForm(AuthFormType.resetPass);
              },
              child: const Text(
                "Forgot Password ?",
                style: TextStyle(
                  color: Color.fromARGB(255, 139, 33, 0),
                ),
              ),
            ),
          
          // Only show Google Sign In button without triggering loading state
          GoogleSignInButton(
            onPressed: () {
              context.read<AuthStatusCubit>().signInWithGoogle();
            }
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
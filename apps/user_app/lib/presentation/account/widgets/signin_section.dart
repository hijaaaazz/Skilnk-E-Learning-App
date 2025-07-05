
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/presentation/account/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import  'package:user_app/presentation/account/widgets/auth_input_fieds.dart';
import  'package:user_app/presentation/account/widgets/authentication_form.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return AuthFormContainer(
      isSignIn: true,
      title: "Sign In",
      fields: [
        AuthInputField(
          controller: emailController,
          hintText: "Email",
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        AuthInputField(
          controller: passwordController,
          hintText: "Password",
          icon: Icons.lock,
          isPassword: true,
        ),
      ],
      buttonText: "Sign In",
      onPressed: () {
        print("Signing in...");
      },
      switchText: "Don't have an account? Sign Up",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(false);
      },
    );
  }
}
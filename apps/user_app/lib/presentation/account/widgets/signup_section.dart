
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/account/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:user_app/presentation/account/widgets/auth_input_fieds.dart';
import 'package:user_app/presentation/account/widgets/authentication_form.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return AuthFormContainer(
      isSignIn: false,
      title: "Sign Up",
      fields: [
        AuthInputField(
          controller: nameController,
          hintText: "Full Name",
          icon: Icons.person,
        ),
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
      buttonText: "Sign Up",
      onPressed: () {
        
      },
      switchText: "Already have an account? Sign In",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(true);
      },
    );
  }
}
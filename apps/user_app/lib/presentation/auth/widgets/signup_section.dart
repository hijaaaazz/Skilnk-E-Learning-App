
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/usecases/signup.dart';
import 'package:user_app/presentation/auth/bloc/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:user_app/presentation/auth/widgets/auth_input_fieds.dart';
import 'package:user_app/presentation/auth/widgets/authentication_form.dart';


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
      
      onPressed: () {
         
        //  log("uyfgbcyergfcbytrfgbc");

        // context.read<ButtonStateCubit>().execute(
        //   usecase: Signupusecase(),
        //   params: UserCreationReq(name: "", email: "mhcnkd4@gmail.com", password: "")
        //   );
      },
      switchText: "Already have an account? Sign In",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(true);
      },
    );
  }
}
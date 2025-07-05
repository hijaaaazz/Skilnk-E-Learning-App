import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import  'package:user_app/core/routes/app_route_constants.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/account/presentation/widgets/buttons.dart';
import  'package:user_app/features/auth/data/models/user_creation_req.dart';
import  'package:user_app/features/auth/presentation/widgets%20/auth_input_fieds.dart';
import  'package:user_app/features/auth/presentation/widgets%20/authentication_form.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // Key for validation
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      key: formKey,
      child: AuthFormContainer(
        isSignIn: false,
        title: "Sign Up",
        fields: [
          AuthInputField(
            controller: nameController,
            hintText: "Full Name",
            icon: Icons.person,
            validator: (value) => value == null || value.trim().isEmpty ? 'Name required' : null,
          ),
          AuthInputField(
            controller: emailController,
            hintText: "Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              
              final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegExp.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              
              return null;
            },
          ),
          AuthInputField(
            controller: passwordController,
            hintText: "Password",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) => value == null || value.length < 6 ? 'Min 6 characters' : null,
          ),
          BlocConsumer<AuthStatusCubit, AuthStatusState>(
            listener: (context, state) {
              if (state.status == AuthStatus.failure && state.message != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message!))
                );
              }

              if (state.status == AuthStatus.emailVerified) {
                context.pushReplacementNamed(AppRouteConstants.accountRouteName);
              } else if (state.status == AuthStatus.authenticated) {
                context.pushReplacementNamed(AppRouteConstants.verificationRouteName, extra: state.user);
              }
            },
            builder: (context, state) {
              // Don't automatically trigger loading state when widget builds
              return PrimaryAuthButton(
                text: "Continue",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthStatusCubit>().signUp(
                      UserCreationReq(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
        switchText: "Already have an account? Sign In",
        onSwitchPressed: () {
          context.read<AuthUiCubit>().switchToForm(AuthFormType.signIn);
        },
      ),
    );
  }
}
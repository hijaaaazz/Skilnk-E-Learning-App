import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/account/presentation/widgets/buttons.dart';
import 'package:user_app/features/auth/data/models/user_signin_model.dart';
import 'package:user_app/features/auth/presentation/widgets%20/auth_input_fieds.dart';
import 'package:user_app/features/auth/presentation/widgets%20/authentication_form.dart';

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
            // Don't automatically trigger loading state when this widget builds
            return PrimaryAuthButton(
              onPressed: () {
                // Only trigger AuthStatusCubit when button is pressed
                context.read<AuthStatusCubit>().signIn(
                  UserSignInReq(
                    email: emailController.text.trim(),
                    password: passwordController.text
                  )
                );
              },
              text: "Sign In"
            );
          },
        ),
      ],
      switchText: "Don't have an account? Sign Up",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().switchToForm(AuthFormType.signUp);
      },
    );
  }
}
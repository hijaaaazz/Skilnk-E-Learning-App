import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/data/models/user_creation_req.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/features/auth/presentation/widgets/auth_input_fieds.dart';
import 'package:tutor_app/features/auth/presentation/widgets/authentication_form.dart';
import 'package:tutor_app/features/auth/presentation/widgets/buttons.dart';
class SignUpForm extends StatefulWidget {
  SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Moved Form outside
      child: AuthFormContainer(
        isSignIn: false,
        title: "Sign Up",
        fields: [
          AuthInputField(
            controller: nameController,
            hintText: "Full Name",
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Name is required";
              }
              return null;
            },
          ),
          AuthInputField(
            controller: emailController,
            hintText: "Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email is required";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          AuthInputField(
            controller: passwordController,
            hintText: "Password",
            icon: Icons.lock,
            isPassword: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.adminVerified) {
                context.pushReplacementNamed(AppRouteConstants.homeRouteName);
              } else if (state.status == AuthStatus.emailVerified) {
                context.pushReplacementNamed(AppRouteConstants.waitingRouteName);
              } else if (state.status == AuthStatus.authenticated) {
                context.pushReplacementNamed(
                  AppRouteConstants.emailVerificationRouteName,
                  extra: state.user,
                );
              } else if (state.status == AuthStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sign up failed. Try again.")),
                );
              }
            },
            builder: (context, state) {
              if (state.status == AuthStatus.loading) {
                return const CircularProgressIndicator();
              }

              return PrimaryAuthButton(
                text: "Sign Up",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      SignUpEvent(
                        request: UserCreationReq(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        ),
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

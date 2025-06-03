import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import 'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/features/auth/presentation/widgets%20/animated_widgets/animated_container.dart';
import 'package:user_app/features/auth/presentation/widgets%20/animated_widgets/animated_welcome_text.dart';
import 'package:user_app/features/auth/presentation/widgets%20/animated_widgets/background_gradient.dart';
import 'package:user_app/features/auth/presentation/widgets%20/authentication_form.dart';
import 'package:user_app/features/auth/presentation/widgets%20/forgot_password_dialog.dart';
import 'package:user_app/features/auth/presentation/widgets%20/signin_section.dart';
import 'package:user_app/features/auth/presentation/widgets%20/signup_section.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get access to existing AuthStatusCubit from parent provider
    final authStatusCubit = context.read<AuthStatusCubit>();
    
    return BlocProvider(
      // Pass the AuthStatusCubit to AuthUiCubit
      create: (context) => AuthUiCubit(),
      child: const _AuthenticationView(),
    );
  }
}

class _AuthenticationView extends StatefulWidget {
  const _AuthenticationView();

  @override
  State<_AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<_AuthenticationView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthUiCubit, AuthUiState>(
      builder: (context, authUiState) {
        final formType = authUiState.formType;

        return Scaffold(
          body: BlocBuilder<AuthStatusCubit, AuthStatusState>(
            builder: (context, authState) {
              // Only show loading if we're explicitly in loading state
              // AND we're not in initial form state
              final isLoading = authState.status == AuthStatus.loading && 
                               formType != AuthFormType.initial;

              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          const BackGroundGradient(),
                          AnimatedWelcomeText(isInitialMode: formType == AuthFormType.initial),
                          AnimatedBackgroundContainer(isInitialMode: formType == AuthFormType.initial),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: formType == AuthFormType.initial
                                ? EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1)
                                : EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                            child: Column(
                              mainAxisAlignment: formType == AuthFormType.initial
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Builder(
                                  builder: (context) {
                                    switch (formType) {
                                      case AuthFormType.signIn:
                                        return const SignInForm();
                                      case AuthFormType.signUp:
                                        return const SignUpForm();
                                      case AuthFormType.resetPass:
                                        return ForgotPasswordView();
                                      case AuthFormType.initial:
                                        return const AuthButtonsContainer();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          if (formType != AuthFormType.initial)
                            Positioned(
                              top: 40,
                              left: 20,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  context.read<AuthUiCubit>().switchToForm(AuthFormType.initial);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Blurred overlay loading
                  if (isLoading)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: const Color.fromARGB(54, 0, 0, 0),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              color: Colors.deepOrange,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
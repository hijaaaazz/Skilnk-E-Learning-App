import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/features/auth/presentation/widgets/animated_widgets/background_gradient.dart';
import 'package:tutor_app/features/auth/presentation/widgets/authentication_form.dart';
import 'package:tutor_app/features/auth/presentation/widgets/forgot_password_dialog.dart';
import 'package:tutor_app/features/auth/presentation/widgets/signin_section.dart';
import 'package:tutor_app/features/auth/presentation/widgets/signup_section.dart';
import 'package:tutor_app/features/auth/presentation/widgets/web/animated_container.dart';
import 'package:tutor_app/features/auth/presentation/widgets/web/welcome_section.dart';

class WebAuthenticationPage extends StatelessWidget {
  const WebAuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthUiCubit(),
      child: const _WebAuthenticationView(),
    );
  }
}

class _WebAuthenticationView extends StatefulWidget {
  const _WebAuthenticationView();

  @override
  State<_WebAuthenticationView> createState() => _WebAuthenticationViewState();
}

class _WebAuthenticationViewState extends State<_WebAuthenticationView> {
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
          backgroundColor: Colors.black,
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isLoading = authState.status == AuthStatus.loading;
              
              return Stack(
                children: [
                  // Background
                  const BackGroundGradient(),
                  
                  // Main content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side - Welcome section
                      Expanded(
                        flex: 5,
                        child: WebWelcomeSection(
                          isInitialMode: formType == AuthFormType.initial,
                        ),
                      ),
                      
                      // Right side - Slanted container with form
                      Expanded(
                        flex: 7,
                        child: WebAnimatedContainer(
                          isInitialMode: formType == AuthFormType.initial,
                          child: Padding(
                            padding:  EdgeInsets.only(
                              left: MediaQuery.of(context).size.width*0.1,
                              right: MediaQuery.of(context).size.width*0.1,
                              bottom: MediaQuery.of(context).size.height*0.2,
                            )
                            ,
                            child: _buildFormContent(context, formType),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Back button
                  if (formType != AuthFormType.initial)
                    Positioned(
                      top: 40,
                      left: 40,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () {
                          context.read<AuthUiCubit>().switchToForm(AuthFormType.initial);
                        },
                      ),
                    ),
                  
                  // Loading overlay
                  if (isLoading) BlurredLoading(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFormContent(BuildContext context, AuthFormType formType) {
    
    switch (formType) {
      case AuthFormType.signIn:
        return const SignInForm();
      case AuthFormType.signUp:
        return SignUpForm();
      case AuthFormType.resetPass:
        return ForgotPasswordView();
      case AuthFormType.initial:
        return const AuthButtonsContainer();
    }
  }
}

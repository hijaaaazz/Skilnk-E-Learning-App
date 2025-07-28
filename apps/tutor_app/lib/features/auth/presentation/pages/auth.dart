import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/widgets/blurred_loading.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/features/auth/presentation/pages/web_uthentication.dart';
import 'package:tutor_app/features/auth/presentation/widgets/animated_widgets/animated_container.dart';
import 'package:tutor_app/features/auth/presentation/widgets/animated_widgets/animated_welcome_text.dart';
import 'package:tutor_app/features/auth/presentation/widgets/animated_widgets/background_gradient.dart';
import 'package:tutor_app/features/auth/presentation/widgets/authentication_form.dart';
import 'package:tutor_app/features/auth/presentation/widgets/forgot_password_dialog.dart';
import 'package:tutor_app/features/auth/presentation/widgets/signin_section.dart';
import 'package:tutor_app/features/auth/presentation/widgets/signup_section.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isLoading = authState.status == AuthStatus.loading;
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  // Determine if we should use web or mobile layout
                  final isWebLayout = constraints.maxWidth > 800;
                  
                  return Stack(
                    children: [
                      if (isWebLayout)
                        WebAuthenticationPage( )
                      else
                        _buildMobileLayout(context, formType),
                      
                      // Back button (positioned differently for web vs mobile)
                      if (formType != AuthFormType.initial)
                        Positioned(
                          top: 40,
                          left: isWebLayout ? 40 : 20,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: isWebLayout ? 28 : 24,
                            ),
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
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildMobileLayout(BuildContext context, AuthFormType formType) {
    return SingleChildScrollView(
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
                  _buildFormContent(context, formType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, AuthFormType formType) {
    return Builder(
      builder: (context) {
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
      },
    );
  }
}

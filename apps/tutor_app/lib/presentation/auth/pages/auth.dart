import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/presentation/auth/bloc/animation_cubit/cubit/auth_animation_cubit.dart';
import 'package:tutor_app/presentation/auth/bloc/animation_cubit/cubit/auth_animation_state.dart';
import 'package:tutor_app/presentation/auth/widgets/animated_container.dart';
import 'package:tutor_app/presentation/auth/widgets/animated_welcome_text.dart';
import 'package:tutor_app/presentation/auth/widgets/authentication_form.dart';
import 'package:tutor_app/presentation/auth/widgets/background_gradient.dart';


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
      builder: (context, state) {
        final isInitialMode = state.isInitialMode;
        final isSignIn = state.formType == AuthFormType.signIn;
        
        return  Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    BackGroundGradient(),
                    AnimatedBackgroundContainer(isInitialMode: isInitialMode,),
                    AnimatedWelcomeText(isInitialMode: isInitialMode,),
                    
                    Padding(
                      padding: 
                      isInitialMode?
                      EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.75)
                      :EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AuthForm(isInitialMode: isInitialMode,isSignIn: isSignIn,),
                          isInitialMode?
                          SizedBox(
                            height: MediaQuery.of(context).size.height  *0.08,
                          ):SizedBox()
                        ]
                      ),
                    ),
                    if (!isInitialMode)
                    Positioned(
                      top: 40,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          context.read<AuthUiCubit>().goBackToInitial();
                        },
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
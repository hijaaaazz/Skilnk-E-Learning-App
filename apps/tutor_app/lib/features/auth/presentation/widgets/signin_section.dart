
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/auth/data/models/user_signin_model.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/features/auth/presentation/blocs/animation_cubit/auth_animation_state.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_event.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_state.dart';
import 'package:tutor_app/features/auth/presentation/widgets/auth_input_fieds.dart';
import 'package:tutor_app/features/auth/presentation/widgets/authentication_form.dart';
import 'package:tutor_app/features/auth/presentation/widgets/buttons.dart';


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
        BlocConsumer<AuthBloc,AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.adminVerified) {
              context.pushReplacementNamed(AppRouteConstants.homeRouteName);
            } else if(state.status == AuthStatus.emailVerified){
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
            return  PrimaryAuthButton(
              text: "Sign In",
          onPressed: (){
            context.read<AuthBloc>().add(
              SignInEvent(request: UserSignInReq(
                email: emailController.text,
                password: passwordController.text)));
          },
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
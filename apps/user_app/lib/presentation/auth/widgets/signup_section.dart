import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';
import 'package:user_app/presentation/account/widgets/buttons.dart';
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
        BlocConsumer<AuthStatusCubit,AuthStatusState>(
          listener:(context, state) {
            if(state.message != null){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
            }
            
            if(state.status == AuthStatus.emailVerified){
              context.pushReplacementNamed(AppRouteConstants.accountRouteName);
            }if(state.status == AuthStatus.authenticated){
              
              context.pushReplacementNamed(AppRouteConstants.verificationRouteName,
              extra: state.user
              );
            }if(state.status == AuthStatus.failure){
              
            }
          },
          builder: (context, state) {
            
            return  PrimaryAuthButton(
            text: "Sign Up",
            onPressed: (){
              context.read<AuthStatusCubit>().signUp(
                UserCreationReq(name: nameController.text, 
                email: emailController.text, 
                password: passwordController.text)
              );
            }
          );
          },
        
        ),
      ],
      
      
      switchText: "Already have an account? Sign In",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(true);
        
      },
    );
  }
}
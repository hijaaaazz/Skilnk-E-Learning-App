
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_state.dart';
import 'package:tutor_app/common/widgets/basic_reactive_button.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/data/auth/models/user_signin_model.dart';
import 'package:tutor_app/domain/auth/usecases/signin.dart';
import 'package:tutor_app/presentation/auth/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/presentation/auth/widgets/auth_input_fieds.dart';
import 'package:tutor_app/presentation/auth/widgets/authentication_form.dart';
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

        BlocProvider(
            create: (_) => ButtonStateCubit(),
            child: BlocConsumer<ButtonStateCubit,ButtonState>(
              listener:(context, state) {
                if(state is ButtonSuccessState){
                  context.goNamed(AppRouteConstants.homeRouteName);
                }
              },
              builder:(context, state) {
                return BasicReactiveButton(
                title: "Sign In",
                textColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: const Color.fromARGB(255, 160, 37, 0),
                onPressed: (){
                  context.read<ButtonStateCubit>().execute(
                    usecase:SignInUseCase(),
                    params: UserSignInReq(
                      email: emailController.text,
                      password: passwordController.text));
                  
                }
              );
              },
            
            ),
          ),
      ],
     
      
      switchText: "Don't have an account? Sign Up",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(false);
      },
    );
  }
}
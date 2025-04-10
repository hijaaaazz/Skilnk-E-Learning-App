import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:user_app/common/bloc/reactivebutton_cubit/button_state.dart';
import 'package:user_app/common/widgets/basic_reactive_button.dart';
import 'package:user_app/core/routes/app_route_constants.dart';
import 'package:user_app/data/auth/models/user_creation_req.dart';
import 'package:user_app/domain/auth/usecases/signup.dart';
import 'package:user_app/presentation/account/blocs/auth_cubit/auth_cubit.dart';
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
        BlocProvider(
            create: (_) => ButtonStateCubit(),
            child: BlocConsumer<ButtonStateCubit,ButtonState>(
              listener:(context, state) {
                if(state is ButtonSuccessState){
                  context.read<AuthStatusCubit>().login();
                  context.pushReplacementNamed(AppRouteConstants.accountRouteName);
                }
              },
              builder: (context, state) {
                return  BasicReactiveButton(
                title: "Sign Up",
                textColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: const Color.fromARGB(255, 160, 37, 0),
                onPressed: (){
                  context.read<ButtonStateCubit>().execute(
                    usecase:Signupusecase(),
                    params: UserCreationReq(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text));
                }
              );
              },
            
            ),
          ),
      ],
      
      
      switchText: "Already have an account? Sign In",
      onSwitchPressed: () {
        context.read<AuthUiCubit>().toggleAuthMode(true);
        
      },
    );
  }
}
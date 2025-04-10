import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_state.dart';
import 'package:tutor_app/common/widgets/basic_reactive_button.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/domain/auth/usecases/signin_with-google.dart';
import 'package:tutor_app/presentation/auth/blocs/animation_cubit/auth_animation_cubit.dart';
import 'package:tutor_app/presentation/auth/widgets/signin_section.dart';
import 'package:tutor_app/presentation/auth/widgets/signup_section.dart';

class AuthForm extends StatelessWidget {
  final bool isInitialMode;
  final bool isSignIn;

  const AuthForm({super.key, required this.isInitialMode, this.isSignIn = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: isInitialMode
              ? const AuthButtonsContainer()
              : (isSignIn ? const SignInForm() : const SignUpForm()),
        ),
      ],
    );
  }
}

class AuthButtonsContainer extends StatelessWidget {
  const AuthButtonsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlocProvider(
          create: (_)=> ButtonStateCubit(),
          child: BasicReactiveButton(
            title: "Sign In",
            backgroundColor: const Color.fromARGB(255, 194, 45, 0),
            onPressed: (){
            context.read<AuthUiCubit>().toggleAuthMode(true);
          } ),
        ),
       
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),

        BlocProvider(
          create: (_) => ButtonStateCubit(),
          child: BasicReactiveButton(
            title: "Sign Up",
            textColor: const Color.fromARGB(255, 194, 45, 0),
            backgroundColor: Colors.white,
            onPressed: (){
            context.read<AuthUiCubit>().toggleAuthMode(false);
          }),
        )
       
      ],
    );
  }
}



class AuthFormContainer extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final String switchText;
  final VoidCallback onSwitchPressed;
  final bool isSignIn;

  const AuthFormContainer({
    super.key,
    required this.title,
    required this.fields,

    required this.switchText,
    required this.onSwitchPressed,
    required this.isSignIn
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 139, 33, 0),
            ),
          ),
          const SizedBox(height: 20),
          ...fields,
          const SizedBox(height: 30),

          
          
          const SizedBox(height: 15),
          if(isSignIn)
            TextButton(
            onPressed: (){

            },
            child: Text(
              "Forgot Password ?",
              style: const TextStyle(
                color: Color.fromARGB(255, 139, 33, 0),
              ),
            ),
          ),
           TextButton(
            
            onPressed: (){
              log('');
            },
             child: BlocProvider(
              create: (context)=> ButtonStateCubit(),
               child: BlocListener<ButtonStateCubit,ButtonState>(
                listener: (context, state) {
                  if(state is ButtonSuccessState){
                    context.goNamed(AppRouteConstants.homeRouteName);
                  }
                },
                 child: Builder(
                   builder: (context) {
                     return BasicReactiveButton(
                     
                      onPressed: () {
                        log("yhguyhuh");
                        context.read<ButtonStateCubit>().execute(
                          usecase: SignInWithGoogleUseCase()
                        );
                      },
                      initialChild: SizedBox(
                        height: MediaQuery.of(context).size.height *0.04,
                         child: Image(
                          image: AssetImage("assets/images/google.png")),
                       ),
                     
                     );
                   }
                 ),
               ),
             ),
           ),
          TextButton(
            onPressed: onSwitchPressed,
            child: Text(
              switchText,
              style: const TextStyle(
                color: Color.fromARGB(255, 139, 33, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




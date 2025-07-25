import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_cubit.dart';
import  'package:user_app/features/account/presentation/blocs/animation_cubit/cubit/auth_animation_state.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthStatusCubit, AuthStatusState>(
      listener: (context, state) {
        if (state.message != null) {
          SnackBarUtils.showMinimalSnackBar(context,state.message!);
        }
        if (state is ResetPasswordSentState) {
          SnackBarUtils.showMinimalSnackBar(context,"Email sent");
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
        
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your email address and we\'ll send you a reset link.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: const Color.fromARGB(255, 175, 41, 0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(101, 255, 255, 255),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 175, 41, 0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color:const Color.fromARGB(255, 175, 41, 0), width: 1.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                       context.read<AuthUiCubit>().switchToForm(AuthFormType.signIn);
                      },
                      child: Text('Cancel',
                          style: TextStyle(color:const Color.fromARGB(255, 175, 41, 0))),
                    ),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                context
                                    .read<AuthStatusCubit>()
                                    .resetPassword(emailController.text)
                                    .then((_) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 175, 41, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text('Send Reset Link'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_cubit.dart';
import 'package:tutor_app/common/bloc/reactivebutton_cubit/button_state.dart';
import 'package:tutor_app/domain/auth/usecases/reset_pass.dart';

// ignore: must_be_immutable
class ResetPassDialog extends StatelessWidget {
  String prefillEmail;
  BuildContext dialogContext;
   ResetPassDialog({super.key,required this.prefillEmail,required this.dialogContext});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(text: prefillEmail);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();


    return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: BlocProvider(
            create: (_) => ButtonStateCubit(),
            child: BlocConsumer<ButtonStateCubit, ButtonState>(
              listener: (context, state) {
                if (state is ButtonSuccessState) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent. Please check your inbox.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is ButtonFailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter your email address to receive a password reset link.',
                          style: TextStyle(fontSize: 14),),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 160, 37, 0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: state is ButtonLoadingState 
                                ? null 
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<ButtonStateCubit>().execute(
                                        usecase: ResetPasswordUseCase(),
                                        params: emailController.text,
                                      );
                                    }
                                  },
                              child: state is ButtonLoadingState
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Send Reset Link'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
  
  }
}

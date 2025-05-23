import 'package:admin_app/common/bloc/cubit/button_cubit.dart';
import 'package:admin_app/common/bloc/cubit/button_state.dart';
import 'package:admin_app/common/widgets/basic_reactive_button.dart';
import 'package:admin_app/core/routes/app_route_constants.dart';
import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:admin_app/features/auth/domain/usecases/signup.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust form width based on available space
          final formWidth = constraints.maxWidth > 500 
              ? 500.0 
              : constraints.maxWidth * 0.9;
          
          // Adjust font sizes based on available width
          final titleSize = constraints.maxWidth > 768 ? 32.0 : 24.0;
          final labelSize = constraints.maxWidth > 768 ? 14.0 : 12.0;
          
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: formWidth),
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth > 768 ? 24 : 16, 
                vertical: constraints.maxWidth > 768 ? 32 : 24
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(titleSize),
                      SizedBox(height: constraints.maxWidth > 768 ? 32 : 24),
                      _buildEmailField(labelSize),
                      SizedBox(height: constraints.maxWidth > 768 ? 16 : 12),
                      _buildPasswordField(labelSize),
                      SizedBox(height: constraints.maxWidth > 768 ? 16 : 12),
                      _buildSignInButton(
                        ontap: () {
                          if (formkey.currentState!.validate()) {
                            context.read<ButtonStateCubit>().execute(
                              usecase: SignInusecase(),
                              params: AdminSignInReq(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                            );
                          }
                        },
                      ),
                      SizedBox(height: constraints.maxWidth > 768 ? 32 : 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTitle(double fontSize) {
    return Text(
      'Welcome Back Admin!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: context.customColors.textBlack,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmailField(double labelSize) {
    return _buildInputField(
      label: 'Email',
      hintText: 'Username or email address',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      controller: _emailController,
      prefixIcon: Icons.email_outlined,
      labelSize: labelSize,
    );
  }

  Widget _buildPasswordField(double labelSize) {
    return _buildInputField(
      label: 'Password',
      hintText: 'Enter your password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      controller: _passwordController,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      labelSize: labelSize,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: context.customColors.borderGrey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }

  Widget _buildInputField({
  required String label,
  required String hintText,
  required TextEditingController controller,
  required IconData prefixIcon,
  required double labelSize,
  required String? Function(String?) validator,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: context.customColors.textBlack,
          fontSize: labelSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          iconColor: context.customColors.textBlack,
          hintStyle: GoogleFonts.outfit(
            color: context.customColors.textBlack,
          ),
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color.fromARGB(255, 206, 206, 206),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.customColors.primaryOrange),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildSignInButton({required Function ontap}) {
    return BlocConsumer<ButtonStateCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          
          context.goNamed(AppRouteConstants.dashboard);
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BasicReactiveButton(
              onPressed: () {
                ontap();
              },
              title: 'Sign In',
              backgroundColor: context.customColors.primaryOrange,
              textColor: context.customColors.textWhite,
            )
          ],
        );
      },
    );
  }
}




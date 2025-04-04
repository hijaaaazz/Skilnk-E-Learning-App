import 'package:admin_app/common/bloc/cubit/button_cubit.dart';
import 'package:admin_app/common/bloc/cubit/button_state.dart';
import 'package:admin_app/common/helpers/navigator.dart';
import 'package:admin_app/common/widgets/basic_reactive_button.dart';
import 'package:admin_app/features/auth/data/models/user_creation_req.dart';
import 'package:admin_app/features/auth/domain/usecases/signup.dart';
import 'package:admin_app/features/landing/presentation/pages/landing.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),  // ✅ Provide at the top
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitle(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildSignInButton(),
                const SizedBox(height: 32),
               
              
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Welcome Back Admin!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: context.customColors.textBlack,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildInputField(
      label: 'Email',
      hintText: 'Username or email address',
      controller: _emailController,
      prefixIcon: Icons.email_outlined,
    );
  }

  Widget _buildPasswordField() {
    return _buildInputField(
      label: 'Password',
      hintText: 'Enter your password',
      controller: _passwordController,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            iconColor: context.customColors.textBlack,
            hintStyle: GoogleFonts.outfit(
              color: context.customColors.textBlack
            ),
            hintText: hintText,
            prefixIcon: Icon(prefixIcon,),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color.fromARGB(255, 206, 206, 206),
           
          ),
        ),
      ],
    );
  }

  
  Widget _buildSignInButton() {
    return BlocConsumer<ButtonStateCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          AppNavigator.push(context, LandingPage()); // ✅ Navigate when successful
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BasicReactiveButton(
              onPressed: () {
                context.read<ButtonStateCubit>().execute(
                  usecase: SignInusecase(),
                  params: AdminSignInReq(
                    email: _emailController.text, 
                    password: _passwordController.text
                  ),
                );
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
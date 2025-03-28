import 'package:flutter/material.dart';
import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              _buildRememberMeAndSignIn(),
              const SizedBox(height: 32),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildSocialLogins(),
            ],
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

  Widget _buildRememberMeAndSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: context.customColors.primaryOrange,
              side:BorderSide(color: context.customColors.textBlack)
            ),
            Text('Remember me', style: TextStyle(color: context.customColors.textBlack)),
          ],
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: context.customColors.primaryOrange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Sign In',
              style: TextStyle(
                color: context.customColors.textWhite,
                fontWeight: FontWeight.bold,
              )),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: context.customColors.borderGrey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('SIGN IN WITH',
              style: TextStyle(
                color: context.customColors.borderGrey,
                fontWeight: FontWeight.w500,
              )),
        ),
        Expanded(child: Divider(color: context.customColors.borderGrey)),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: context.customColors.primaryWhite,
            foregroundColor: context.customColors.textBlack,
            side: BorderSide(color: context.customColors.borderGrey),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(
            children: [
              Image.asset("assets/images/google.png", width: 24),
              const SizedBox(width: 10),
              Text('Google'),
            ],
          ),
        ),
      ],
    );
  }
}
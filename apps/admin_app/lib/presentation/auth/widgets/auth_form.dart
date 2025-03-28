import 'package:flutter/material.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  _buildTitle(),
                  SizedBox(height: 32),

                  // Email Input
                  _buildEmailField(),
                  SizedBox(height: 16),

                  // Password Input
                  _buildPasswordField(),
                  SizedBox(height: 16),

                  // Remember Me and Sign In Row
                  _buildRememberMeAndSignIn(),
                  SizedBox(height: 32),

                  // Divider
                  _buildDivider(),
                  SizedBox(height: 16),

                  // Social Login Buttons
                  _buildSocialLogins(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Text(
      'Welcome Back Admin!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: _inputDecoration(
            hintText: 'Username or email address',
            prefixIcon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _inputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: Colors.grey),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.orange, width: 2),
      ),
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
              activeColor: Colors.orange,
            ),
            Text(
              'Remember me',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _performLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'SIGN IN WITH',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialLoginButton(
          icon: Icons.golf_course,  // Replace with Google icon
          label: 'Google',
          color: Colors.red,
        ),
        SizedBox(width: 16),
        _socialLoginButton(
          icon: Icons.facebook,  // Replace with Facebook icon
          label: 'Facebook',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _socialLoginButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return OutlinedButton.icon(
      onPressed: () {
        // Implement social login logic
      },
      icon: Icon(icon, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _performLogin() {
    // Implement login logic
    final email = _emailController.text;
    final password = _passwordController.text;
    
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement actual authentication
    print('Login attempted with: $email');
  }
}
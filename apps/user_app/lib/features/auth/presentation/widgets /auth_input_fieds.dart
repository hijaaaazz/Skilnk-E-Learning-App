import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // ✅ New

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator, // ✅ New
  });

  @override
  Widget build(BuildContext context) {
    bool _obscureText = isPassword;

    return StatefulBuilder(
      builder: (context, setState) => Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword && _obscureText,
          keyboardType: keyboardType,
          validator: validator, // ✅ Use validator here
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

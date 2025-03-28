import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutor_app/core/theme/custom_colors_extension.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 0, 0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        style: TextStyle(
          color: context.customColors.primaryRed
        ),
      
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,
        keyboardType: widget.keyboardType,
        cursorWidth: 3,
        cursorHeight: 16,
        cursorColor: context.customColors.primaryOrange,
        decoration: InputDecoration(
          
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width* 0.1),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.outfit(color: context.customColors.neutralGrey),
          prefixIcon: Icon(widget.icon, color: context.customColors.neutralGrey),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: context.customColors.primaryOrange,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color.fromARGB(255, 240, 240, 240),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Curved border
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

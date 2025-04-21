import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // 👈 Added validator

  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator, // 👈 Required for form validation
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
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField( // 👈 Changed from TextField to TextFormField
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator, // 👈 Added validator here
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.outfit(
            color: const Color.fromARGB(255, 134, 134, 134),
          ),
          prefixIcon: Icon(widget.icon, color: const Color.fromARGB(255, 134, 134, 134)),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 139, 33, 0),
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
            borderRadius: BorderRadius.circular(30),
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

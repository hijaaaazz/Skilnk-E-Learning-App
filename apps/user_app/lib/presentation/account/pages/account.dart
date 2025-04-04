import 'package:flutter/material.dart';
import 'package:user_app/presentation/auth/pages/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AuthenticationSection()
        ),
      ),
    );
  }
}

import 'package:admin_app/features/auth/presentaion/pages/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            // Perform Firebase logout
            try {
              await FirebaseAuth.instance.signOut();

              // After logout, you can navigate the user to the login page or home page
              // You can either navigate using a Navigator or use a Cubit to change state
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => AuthenticationPage()), // Replace with your LoginPage
              );
            } catch (e) {
              // If an error occurs while logging out, you can show an error message
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to log out: $e')),
              );
            }
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}

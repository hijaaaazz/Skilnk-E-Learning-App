import 'package:admin_app/presentation/auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Row(),
          Expanded(
            child: Row(
              children: [
                Container(

                  color: Color(0xFFEBEBFF),
                  height:  MediaQuery.of(context).size.height ,
                  width: MediaQuery.of(context).size.width *0.45,
                  child: Image(image: AssetImage("assets/images/sally_illustration.png")),
                ),
                Expanded(
                  child: Center(
                    child: LoginForm(),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}


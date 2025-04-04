import 'package:admin_app/core/theme/custom_colors_extension.dart';
import 'package:admin_app/features/auth/presentaion/widgets/auth_form.dart';
import 'package:admin_app/features/auth/presentaion/widgets/nav_bar.dart';
import 'package:flutter/material.dart';


class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          NavBar(),
          
          Expanded(
            child: Row(
              children: [
                Container(
                  color:context.customColors.backgroundLightBlue,
                  height:  MediaQuery.of(context).size.height ,
                  width: MediaQuery.of(context).size.width *0.45,
                  child: Image(image: AssetImage("assets/images/sally_illustration.png")),
                ),
                Expanded(
                  child: ColoredBox(
                    color: context.customColors.primaryWhite,
                    child: Center(
                      child: LoginForm(),
                    ),
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


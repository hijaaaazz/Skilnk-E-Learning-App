import 'package:flutter/material.dart';
import 'package:user_app/presentation/account/widgets/slanded_clipper.dart';

class AuthenticationSection extends StatelessWidget {
  const AuthenticationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(


          children: [

            
            SizedBox(
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/connections.jpg")),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                     const Color.fromARGB(0, 0, 195, 255),
                     const Color.fromARGB(255, 0, 195, 255),
                  ]
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: SlantedClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *0.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height*0.1
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("hi",)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




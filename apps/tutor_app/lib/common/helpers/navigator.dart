import 'package:flutter/material.dart';

class AppNavigator{

  static void push(BuildContext context,Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
  }
  static void pushAndRemoveUntil(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false, // This removes all previous routes
  );
}


}
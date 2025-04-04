import 'package:flutter/material.dart';

class AppNavigator{

  static void push(BuildContext context,Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
  }

  static void pushAndReplacement(BuildContext context,Widget page){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> page));
  }

}
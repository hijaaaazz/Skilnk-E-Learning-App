import 'package:flutter/material.dart';

class AppNavigator{

  static void push(BuildContext context,Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
  }

}
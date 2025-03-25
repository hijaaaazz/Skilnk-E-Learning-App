import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_app/presentation/splash/pages/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:const Color.fromARGB(255, 0, 0, 0), 
    systemNavigationBarIconBrightness: Brightness.dark
    
  ));
  runApp(const Skilnk());
}

class Skilnk extends StatelessWidget {
  const Skilnk({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 13, 3, 31),
        primaryColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/core/theme/theme.dart';
import 'package:user_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:user_app/presentation/account/cubit/auth_cubit.dart';
import 'package:user_app/presentation/landing/pages/landing.dart';
import 'package:user_app/presentation/splash/pages/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromARGB(255, 0, 0, 0),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const Skilnk());
}

class Skilnk extends StatelessWidget {
  const Skilnk({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> LandingNavigationCubit()),
        BlocProvider(create: (_)=> AuthCubit())
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,

        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    );
  }
}


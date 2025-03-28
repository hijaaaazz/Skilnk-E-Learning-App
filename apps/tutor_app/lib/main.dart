import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/theme/theme.dart';
import 'package:tutor_app/firebase_options.dart';
import 'package:tutor_app/presentation/auth/bloc/auth_cubit/auth_cubit.dart';
import 'package:tutor_app/presentation/auth/bloc/slanded_clipper_animation.dart/slanded_clipper_animation_cubit.dart';
import 'package:tutor_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:tutor_app/presentation/splash/pages/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        BlocProvider(create: (_)=> AuthCubit()),
        BlocProvider(create: (_)=> SlantedAnimationCubit())
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


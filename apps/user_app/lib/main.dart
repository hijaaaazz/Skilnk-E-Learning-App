import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/bloc/cubit/button_cubit.dart';
import 'package:user_app/core/configs/theme/theme.dart';
import 'package:user_app/firebase_options.dart';
import 'package:user_app/presentation/account/blocs/slanded_clipper_animation.dart/slanded_clipper_animation_cubit.dart';
import 'package:user_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:user_app/presentation/splash/pages/splash.dart';
import 'package:user_app/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

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
        BlocProvider(create: (_) => SlantedAnimationCubit()),
        BlocProvider(create: (_) => ButtonStateCubit())
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


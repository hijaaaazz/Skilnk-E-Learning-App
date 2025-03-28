import 'package:admin_app/core/theme/theme.dart';
import 'package:admin_app/firebase_options.dart';
import 'package:admin_app/presentation/auth/pages/authentication.dart';
import 'package:admin_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:admin_app/presentation/landing/pages/landing.dart';
import 'package:admin_app/presentation/profile/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Future<void> main() async {
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
        BlocProvider(create: (_)=> AuthCubit())
      ],
      child: MaterialApp(
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: AuthenticationPage(),
      ),
    );
  }
}


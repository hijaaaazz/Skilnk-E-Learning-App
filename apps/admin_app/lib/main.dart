import 'package:admin_app/core/routes/app_routes_config.dart';
import 'package:admin_app/core/theme/theme.dart';
import 'package:admin_app/features/splash/presentation/pages/splash.dart';
import 'package:admin_app/features/users/presentation/bloc/cubit/user_management_cubit.dart';
import 'package:admin_app/firebase_options.dart';
import 'package:admin_app/features/landing/presentation/bloc/landing_navigation_cubit.dart';
import 'package:admin_app/service_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
        //BlocProvider(create: (_)=> AuthCubit()),
      
      ],
      child: MaterialApp.router(
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes().router,
      ),
    );
  }
}


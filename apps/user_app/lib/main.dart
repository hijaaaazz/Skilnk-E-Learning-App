import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import  'package:user_app/core/configs/theme/theme.dart';
import  'package:user_app/core/routes/app_routes_config.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/home/presentation/bloc/courses/course_bloc_bloc.dart';
import  'package:user_app/features/library/presentation/bloc/library_bloc.dart';
import  'package:user_app/firebase_options.dart';
import  'package:user_app/service_locator.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  log("Current directory: ${Directory.current.path}");
  

  await dotenv.load(fileName: ".env");
  await initializeDependencies();
  
  await FlutterDownloader.initialize(debug: true);
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
        BlocProvider(create: (_) => AuthStatusCubit()),
        BlocProvider(create: (_) => CourseBlocBloc()..add(FetchCategories())..add(FetchCourses())..add(FetchMentors())..add(FetchBannerInfo())),
        BlocProvider(create: (_) => LibraryBloc())

      ],
      child: MaterialApp.router(
        title: "Skilnk",
        themeMode: ThemeMode.light,

        theme: MyThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes().router,
      
      ),
    );
  }
}


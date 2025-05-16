import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tutor_app/core/routes/app_routes_config.dart';
import 'package:tutor_app/core/theme/theme.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/firebase_options.dart';
import 'package:tutor_app/service_locator.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  initializeDependencies();
  
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
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CoursesBloc())
      ],
      child: MaterialApp.router(
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes().router,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/presentation/explore/pages/explore.dart';
import 'package:user_app/presentation/home/pages/home.dart';
import 'package:user_app/presentation/landing/cubit/landing_navigation_cubit.dart';
import 'package:user_app/presentation/landing/widgets/navigation_bar.dart';
import 'package:user_app/presentation/library/pages/library.dart';
import 'package:user_app/presentation/account/pages/account.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static final List<Widget> pages = [
    HomePage(),
    ExplorePage(),
    LibraryPage(),
    AccountPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingNavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: pages[currentIndex], // Show the correct page
          bottomNavigationBar: buildBottomNavbar(currentIndex, context),
        );
      },
    );
  }
}



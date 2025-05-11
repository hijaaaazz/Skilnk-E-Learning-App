import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/features/courses/presentation/pages/advanced_info_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/basic_info_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/curicullum_submition.dart';
import 'package:tutor_app/features/courses/presentation/pages/publish_couse.dart';

class AddCourseWrapper extends StatelessWidget {
  final GoRouterState state;

  const AddCourseWrapper({super.key, required this.state});

  @override
Widget build(BuildContext context) {
  final subLocation = state.uri.toString(); // full matched path

  List<Page> pages = [const MaterialPage(child: StepBasicInfo())];

  // if (subLocation.endsWith('/basicinfo')) {
  //   pages.add();
  // } else if (subLocation.endsWith('/advanced')) {
  //   pages.add(const MaterialPage(child: StepAdvancedInfo()));
  // } else if (subLocation.endsWith('/curriculum')) {
  //   pages.add(const MaterialPage(child: StepCurriculum()));
  // } else if (subLocation.endsWith('/publish')) {
  //   pages.add(const MaterialPage(child: StepPublish()));
  // } else {
  //   // fallback: maybe navigate to basicinfo or show an error/start page
  //   pages.add(const MaterialPage(child: StepBasicInfo()));
  // }

  return Navigator(
    onPopPage: (route, result) => route.didPop(result),
    pages: pages,
  );
}

}


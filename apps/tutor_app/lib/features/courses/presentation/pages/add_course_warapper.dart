import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/features/courses/presentation/pages/basic_info_submition.dart';

class AddCourseWrapper extends StatelessWidget {
  final GoRouterState state;

  const AddCourseWrapper({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // ignore: deprecated_member_use
      onPopPage: (route, result) => route.didPop(result),
      pages: [
        const MaterialPage(child: StepBasicInfo()),
      ],
    );
  }
}

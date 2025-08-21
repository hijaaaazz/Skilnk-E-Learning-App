import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/presentation/pages/basic_info_submition.dart';

// ignore: must_be_immutable
class AddCourseWrapper extends StatefulWidget {
  final GoRouterState state;
  CourseEntity? courseToUpdate;

   AddCourseWrapper({super.key, required this.state,this.courseToUpdate});

  @override
  State<AddCourseWrapper> createState() => _AddCourseWrapperState();
}

class _AddCourseWrapperState extends State<AddCourseWrapper> {

 
  @override
  Widget build(BuildContext context) {
    return Navigator(
      // ignore: deprecated_member_use
      onPopPage: (route, result) => route.didPop(result),
      pages: [
         MaterialPage(child: StepBasicInfo()),
      ],
    );
  }
}

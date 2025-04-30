import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/common/widgets/app_bar.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BasicAppBar(title: "My Courses",

        actions: [
          IconButton(onPressed: (){
            context.pushNamed(AppRouteConstants.addnewCourseRouteName);
          }, icon: Icon(Icons.add_box_outlined,color: Colors.white,))
        ],
      ),
      body: Center(
        child: Text("Courses Page"),
      ),
    );
  }
}
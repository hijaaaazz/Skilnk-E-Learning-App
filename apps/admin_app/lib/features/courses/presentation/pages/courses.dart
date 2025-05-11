
import 'package:admin_app/core/routes/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     body: Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.005,
        horizontal: MediaQuery.of(context).size.width * 0.025,
      ),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: (){
                  context.goNamed(AppRouteConstants.coursecategory);
                }, child:
                Text(
                  "Course Categories",
                ))
            ],
          )
        ],
       ),
     ),
    );
  }
}
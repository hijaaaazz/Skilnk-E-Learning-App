import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_bar.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BasicAppBar(title: "My Courses",

        actions: [
          IconButton(onPressed: (){
            
          }, icon: Icon(Icons.add_box_outlined,color: Colors.white,))
        ],
      ),
      body: Center(
        child: Text("Courses Page"),
      ),
    );
  }
}
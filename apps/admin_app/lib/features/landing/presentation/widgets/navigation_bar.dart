
//   import 'package:admin_app/features/landing/presentation/bloc/landing_navigation_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// Widget buildDrawer(int currentIndex, BuildContext context) {
//   List<Map<String, dynamic>> drawerItems = [
//     {"icon": Icons.dashboard, "title": "Dashboard", "color": Colors.blue},
//     {"icon": Icons.menu_book, "title": "Courses", "color": Colors.green},
//     {"icon": Icons.people, "title": "Manage Users", "color": Colors.purple},
//     {"icon": Icons.person_add, "title": "Manage Instructors", "color": Colors.red},
//     {"icon": Icons.settings, "title": "Logout", "color": Colors.grey},
//   ];

//   return Drawer(
//     child: Column(
//       children: [
        
//         Container(
//           child: ListView.builder(
//             shrinkWrap: true, 
//             itemCount: drawerItems.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 leading: Icon(
//                   drawerItems[index]["icon"], 
//                   color: currentIndex == index ? drawerItems[index]["color"] : Colors.grey,
//                 ),
//                 title: Text(drawerItems[index]["title"]),
//                 onTap: () {
//                   context.read<LandingNavigationCubit>().updateIndex(index);
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           ),
//         ),

//         ListTile(
//               leading: Icon(
//                 Icons.logout_rounded,
//                 color:Colors.deepOrange
//               ),
//               title: Text("Logout"),
//               onTap: () {
//                 showDialog(context: context, builder: (BuildContext context){
//                   return Container();
//                 });
//               },
//             )


//       ],
//     ),
//   );

// }

import 'package:admin_app/common/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
   LandingPage({required this.navigationShell, Key? key}) : super(key: key);

  final StatefulNavigationShell navigationShell;

final List<Destination> destinations = [
  Destination(icon: Icons.dashboard, title: 'Dashboard', index: 0),
  Destination(icon: Icons.book, title: 'Courses', index: 1),
  Destination(icon: Icons.person, title: 'Manage Mentors', index: 2),
  Destination(icon: Icons.people, title: 'Manage Users', index: 3),
];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      drawer: _buildDrawer(context),
      drawerEnableOpenDragGesture: false,
      appBar: SkilnkAppBar(
        title: (destinations[navigationShell.currentIndex].title),
      ),
      body: navigationShell,
      bottomNavigationBar: _buildFooter(), // optional
    );
  }
 


 Widget _buildDrawer(BuildContext context) {
  return Drawer(
    width: 280,
    child: Container(
      color: const Color(0xFF1D1F26),
      child: Column(
        children: [
          // Header
          Container(
            width: 280,
            height: 70,
            padding: const EdgeInsets.only(left: 24, top: 15),
            child: Row(
              children: const [
                SizedBox(width: 30, height: 30),
                SizedBox(width: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Skil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'nk',
                        style: TextStyle(
                          color: Color(0xFFFF6636),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          ...destinations.map((item) => _drawerItem(context, item)).toList(),

          const Spacer(),

          // Logout button
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                children: const [
                  Icon(Icons.logout_rounded, color: Colors.redAccent),
                  SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}



  Widget _drawerItem(BuildContext context, Destination item) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      if (item.index < navigationShell.route.branches.length) {
        navigationShell.goBranch(item.index);
      } else {
        // Handle sign-out or other action
      }
    },
    child: Container(
      width: double.infinity,
      height: 48,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 24, top: 12),
      child: Row(
        children: [
          Icon(item.icon, size: 24, color: const Color(0xFF8C93A3)),
          const SizedBox(width: 12),
          Text(
            item.title,
            style: const TextStyle(
              color: Color(0xFF8C93A3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildFooter() {
    return Container(
      height: 50,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Text(
        '© 2025 Skilnk',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
class Destination {
  final IconData icon;
  final String title;
  final int index;

  Destination({required this.icon, required this.title, required this.index});
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Logout'),
          onPressed: () {
            Navigator.pop(context);
            // 🔁 Add your logout logic here
            // Example: context.go("/login");
          },
        ),
      ],
    ),
  );
}

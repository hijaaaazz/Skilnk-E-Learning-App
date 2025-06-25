import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildBottomNavbar(StatefulNavigationShell navigationShell) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final destination = entry.value;
            final isSelected = navigationShell.currentIndex == index;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(isSelected ? 10 : 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.deepOrange.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          destination.icon.icon,
                          size: isSelected ? 24 : 22,
                          color: isSelected 
                              ? Colors.deepOrange.shade700
                              : Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(height: 4),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        height: 2,
                        width: isSelected ? 20 : 0,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade700,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

class Destination {
  const Destination({
    required this.label,
    required this.icon,
  });

  final String label;
  final Icon icon;
}

const destinations = [
  Destination(label: "Dashboard", icon: Icon(Icons.dashboard_outlined)),
  Destination(label: "Courses", icon: Icon(Icons.library_books_outlined)),
  Destination(label: "Chats", icon: Icon(Icons.chat_bubble_outline)),
  Destination(label: "Profile", icon: Icon(Icons.person_outline)),
];

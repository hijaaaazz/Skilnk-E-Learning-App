import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/features/chat/data/models/student_model.dart';

class StudentHeader extends StatelessWidget implements PreferredSizeWidget {
  final StudentEntity student;
  final bool isTyping;

  const StudentHeader({
    super.key,
    required this.student,
    this.isTyping = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80); // height of AppBar

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(onPressed: (){
            context.pop();
          }, icon: Icon(Icons.arrow_back_ios)),
          CircleAvatar(
            radius: 24,
            // ignore: unnecessary_null_comparison
            backgroundImage: student.imageUrl != null
                ? NetworkImage(student.imageUrl)
                : null,
            backgroundColor: Colors.grey[300],
            // ignore: unnecessary_null_comparison
            child: student.imageUrl == null
                ? Text(
                    student.name[0], // only initial if image missing
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isTyping ? 'Typing...' : 'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}

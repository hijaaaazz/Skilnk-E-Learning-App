import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class MentorHeader extends StatelessWidget implements PreferredSizeWidget {
  final MentorEntity mentor;
  final bool isTyping;

  const MentorHeader({
    super.key,
    required this.mentor,
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
            backgroundImage: mentor.imageUrl != null
                ? NetworkImage(mentor.imageUrl)
                : null,
            backgroundColor: Colors.grey[300],
            // ignore: unnecessary_null_comparison
            child: mentor.imageUrl == null
                ? Text(
                    mentor.name[0], // only initial if image missing
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
                  mentor.name,
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

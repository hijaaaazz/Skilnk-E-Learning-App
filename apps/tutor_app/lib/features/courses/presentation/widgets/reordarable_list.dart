import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_text.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';

class ReorderableContentList extends StatelessWidget {
  final Function(int oldIndex, int newIndex) onReorder;
  final List<dynamic> items; // Replace with your actual data model
  final Function(int index)? onEdit;
  final Function(int index)? onDelete;
  
  // Add optional parameters for styling
  final Color? cardColor;
  final Color? dragHandleColor;
  final Color? dragFeedbackColor;

  const ReorderableContentList({
    Key? key,
    required this.onReorder,
    required this.items,
    this.onEdit,
    this.onDelete,
    this.cardColor,
    this.dragHandleColor,
    this.dragFeedbackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.56,
      child:ReorderableListView.builder(
          buildDefaultDragHandles: false, // Disable default handles
          dragStartBehavior: DragStartBehavior.down,
          onReorder: onReorder,
          itemCount: items.isEmpty ? 10 : items.length, // Using sample data if empty
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            // Custom feedback widget during drag
            return Card(
                    color:Colors.white,
                    
                    shadowColor: const Color.fromARGB(0, 255, 255, 255).withOpacity(0.2),
                    child: child,
                  );
          },
          itemBuilder: (context, index) {
            return _buildListItem(
              context, 
              index,
              
            );
          },
        ),
    );
  }
  
  Widget _buildListItem(BuildContext context, int index) {
    LectureCreationReq item = items[index];
    return Card(
      key: ValueKey(index),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          // Leading drag handle icon with custom feedback
          leading: ReorderableDragStartListener(
            index: index,
            child: Icon(Icons.menu,
            size: 20, color: Colors.grey),
          ),
          // Main content
          title: Row(
            children: [
              Expanded(
                flex: 3,
                child: AppText(
                  text: item.title!,
                  
                  weight: FontWeight.w500,
                ),
              ),
            
            ],
          ),
          // Trailing actions
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: const Color.fromARGB(255, 255, 0, 0),
                visualDensity: VisualDensity.compact,
                onPressed: onEdit != null ? () => onEdit!(index) : null,
              ),
              IconButton(
                icon: const Icon(Icons.cancel, size: 20),
                color: const Color.fromARGB(255, 255, 0, 0),
                visualDensity: VisualDensity.compact,
                onPressed: onDelete != null ? () => onDelete!(index) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage with custom colors:
/*
SizedBox(
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.56,
  child: ReorderableContentList(
    items: state.lessons,
    onReorder: (oldIndex, newIndex) {
      context.read<AddCourseCubit>().reorderLessons(oldIndex, newIndex);
    },
    onEdit: (index) => context.read<AddCourseCubit>().editLesson(index),
    onDelete: (index) => context.read<AddCourseCubit>().removeLesson(index),
    cardColor: Colors.white,
    dragHandleColor: Colors.grey,
    dragFeedbackColor: Colors.grey.shade50,
  ),
)
*/
import 'package:flutter/material.dart';

class StepCurriculum extends StatefulWidget {
  final List<String> lessons;
  final Function(String) onAddLesson;

  const StepCurriculum({
    super.key,
    required this.lessons,
    required this.onAddLesson,
  });

  @override
  State<StepCurriculum> createState() => _StepCurriculumState();
}

class _StepCurriculumState extends State<StepCurriculum> {
  final _lessonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Add Lessons'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _lessonController,
                decoration: const InputDecoration(hintText: 'Lesson title'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (_lessonController.text.isNotEmpty) {
                  widget.onAddLesson(_lessonController.text);
                  _lessonController.clear();
                }
              },
            )
          ],
        ),
        const SizedBox(height: 12),
        ...widget.lessons
            .map((lesson) => ListTile(title: Text(lesson)))
            ,
      ],
    );
  }
}

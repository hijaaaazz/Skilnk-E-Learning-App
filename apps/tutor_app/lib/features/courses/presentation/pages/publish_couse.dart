
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/widgets/step_page.dart';
import 'dart:io';


class StepPublish extends StatelessWidget {
  const StepPublish({super.key});

  @override
  Widget build(BuildContext context) {
    return CourseStepPage(
      icon: Icons.publish_rounded,
      title: "Publish",
      bodyContent:PublishBody(),
      onNext: () async {
        
         context.read<AddCourseCubit>().uploadCourse("hfruefhufjweuhguy");
      }

    );
  }
}

class PublishBody extends StatelessWidget {

  const PublishBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AddCourseCubit, AddCourseState>(
        builder: (context, courseState) {

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Course Preview',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1D1F26),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: -0.24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Thumbnail
                  _buildSectionTitle('Course Thumbnail'),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE8EAEF)),
                    ),
                    child: courseState.thumbnailPath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(courseState.thumbnailPath),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Color(0xFF8C93A3),
                          ),
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  _buildPropertyPreview(
                    label: 'Title',
                    value: courseState.title.isNotEmpty ? courseState.title : 'Untitled Course',
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  _buildPropertyPreview(
                    label: 'Description',
                    value: courseState.description.isNotEmpty ? courseState.description : 'No description provided',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  
                  // Category & Language
                  Row(
                    children: [
                      Expanded(
                        child: _buildPropertyPreview(
                          label: 'Category',
                          value: courseState.category?.title ?? 'Uncategorized',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPropertyPreview(
                          label: 'Language',
                          value: courseState.language ?? 'Not specified',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Level & Pricing Info (assuming free for now)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPropertyPreview(
                          label: 'Level',
                          value: courseState.level ?? 'Not specified',
                        ),
                      ),
                      const SizedBox(width: 16),
                       Expanded(
                        child: _buildPropertyPreview(
                          label: 'Price',
                          value: courseState.isPaid && courseState.price !=null ? courseState.price! : 'Free',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height:  16,),

                  Row(
                    children: [
                      Expanded(
                        child: _buildPropertyPreview(
                          label: 'Duration',
                          value: courseState.courseDuration != null
                              ? _formatDuration(courseState.courseDuration!)
                              : 'Not specified',
                        ),

                      ),
                      
                    ],
                  ),

                  
                  const SizedBox(height: 24),
                  
                  // Lectures
                  _buildSectionTitle('Lectures (${courseState.lessons.length})'),
                  const SizedBox(height: 8),
                  
                  ...courseState.lessons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final lecture = entry.value;
                    return _buildLectureCard(index + 1, lecture, context);
                  }),
                  
                  if (courseState.lessons.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE8EAEF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'No lectures added',
                          style: TextStyle(
                            color: Color(0xFF8C93A3),
                            fontSize: 16,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 40),
                ],
              ),
            );
        },
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1D1F26),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 1.33,
        ),
      ),
    );
  }
  
  Widget _buildPropertyPreview({
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1D1F26),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.57,
            letterSpacing: -0.14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: const Color(0xFFE8EAEF),
            ),
          ),
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF4D5565),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  List<String> parts = [];

  if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');
  if (minutes > 0) parts.add('$minutes minute${minutes > 1 ? 's' : ''}');
  if (seconds > 0 || parts.isEmpty) parts.add('$seconds second${seconds > 1 ? 's' : ''}');

  return parts.join(' ');
}

  
  Widget _buildLectureCard(int index, LectureCreationReq lecture, BuildContext context) {
    // Calculate duration in minutes (assuming duration might be in a different format in your actual model)
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8EAEF),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                lecture.title ?? 'Untitled Lecture',
                style: const TextStyle(
                  color: Color(0xFF1D1F26),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
          ],
        ),
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            lecture.description ?? 'No description',
            style: const TextStyle(
              color: Color(0xFF4D5565),
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          if (lecture.videoUrl != null && lecture.videoUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.video_library_outlined,
                  size: 16,
                  color: Color(0xFF8C93A3),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Video:',
                  style: TextStyle(
                    color: Color(0xFF8C93A3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        _getFileName(lecture.videoUrl!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(_formatDuration(lecture.duration!))
                    ],
                  ),
                ),
              ],
            ),
          ],
          if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Color(0xFF8C93A3),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Lecture Notes:',
                  style: TextStyle(
                    color: Color(0xFF8C93A3),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _getFileName(lecture.notesUrl!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  // Helper to extract filename from path
  String _getFileName(String path) {
    return path.split('/').last;
  }
}
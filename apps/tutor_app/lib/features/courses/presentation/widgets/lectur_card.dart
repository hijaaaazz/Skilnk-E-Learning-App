import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_cubit.dart';
import 'package:video_player/video_player.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/presentation/widgets/utils.dart';
import 'dart:io';

import 'video_player_controls.dart';

class LectureCard extends StatefulWidget {
  final int index;
  final LectureCreationReq lecture;

  const LectureCard({
    super.key,
    required this.index,
    required this.lecture,
  });

  @override
  State<LectureCard> createState() => _LectureCardState();
}

class _LectureCardState extends State<LectureCard> {
  VideoPlayerController? _controller;
  bool _isExpanded = false;
   

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initializeVideo() {
  final bool isEditing = context.read<AddCourseCubit>().state.isEditing ?? false;
  final String? videoUrl = widget.lecture.videoUrl;

  if (videoUrl != null && videoUrl.isNotEmpty) {
    if (isEditing) {
      if (videoUrl.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl) )
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      } else {
        _controller = VideoPlayerController.file(File(videoUrl))
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      }
    } else {
      _controller = VideoPlayerController.file(File(videoUrl))
        ..initialize().then((_) {
          if (mounted) setState(() {});
        });
    }
  }
}


  void _disposeVideo() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {

     
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
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
          
          if (expanded) {
            _initializeVideo();
          } else {
            _disposeVideo();
          }
        },
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                widget.index.toString(),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.lecture.title ?? 'Untitled Lecture',
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
            widget.lecture.description ?? 'No description',
            style: const TextStyle(
              color: Color(0xFF4D5565),
              fontSize: 14,
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
          if (widget.lecture.videoUrl != null && widget.lecture.videoUrl!.isNotEmpty) ...[
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getFileName(widget.lecture.videoUrl!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (widget.lecture.duration != null)
                        Text(formatDuration(widget.lecture.duration!)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_controller != null && _controller!.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller!),
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFF3F51B5),
                        bufferedColor: Color(0x22C8C8C8),
                        backgroundColor: Color(0x44FFFFFF),
                      ),
                    ),
                    VideoPlayerControls(controller: _controller!),
                  ],
                ),
              )
            else if (_isExpanded)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
          if (widget.lecture.notesUrl != null && widget.lecture.notesUrl!.isNotEmpty) ...[
            const SizedBox(height: 16),
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
                    getFileName(widget.lecture.notesUrl!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    context.pushNamed(AppRouteConstants.pdfViewer,extra:widget.lecture.notesUrl );
                  },
                ),
              ],
            ),
           
          ],
        ],
      ),
    );
  }
}
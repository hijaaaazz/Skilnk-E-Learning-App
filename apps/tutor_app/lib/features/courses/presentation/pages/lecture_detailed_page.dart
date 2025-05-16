import 'package:flutter/material.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';
import 'package:tutor_app/features/courses/presentation/widgets/video_player_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:go_router/go_router.dart';


class LectureDetailScreen extends StatefulWidget {
  final LectureEntity lecture;

  const LectureDetailScreen({super.key, required this.lecture});

  @override
  State<LectureDetailScreen> createState() => _LectureDetailScreenState();
}

class _LectureDetailScreenState extends State<LectureDetailScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lecture.videoUrl));
    await _controller!.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.lecture.title),
      backgroundColor: Theme.of(context).primaryColor,
    ),
    body: Padding(
      padding: const EdgeInsets.all(15),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Video Player Section (16:9)
               AspectRatio(
  aspectRatio: 16 / 9,
  child: Container(
    color: Colors.black, // So that letterboxing is visible as black bars
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Wrap the VideoPlayer in a FittedBox
        FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
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
  ),
),

      
                // Lecture Details (shrinked height for no scrolling)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lecture.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 4),
                            Text('${widget.lecture.duration.inMinutes} minutes'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.lecture.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
      
                        const Text(
                          'Lecture Notes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
      
                        // PDF viewer in 16:9 ratio
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const PDF().cachedFromUrl(
                                  widget.lecture.notesUrl,
                                  placeholder: (progress) => Center(
                                    child: CircularProgressIndicator(value: progress),
                                  ),
                                  errorWidget: (error) => Center(
                                    child: Text('Failed to load PDF: $error'),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                                    onPressed: () {
                                      context.pushNamed(
                                        AppRouteConstants.pdfViewer,
                                        extra: widget.lecture.notesUrl,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    ),
  );
}

}

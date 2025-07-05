import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/account/presentation/blocs/auth_cubit/auth_cubit.dart';
import  'package:user_app/features/home/data/models/lecture_progress_model.dart';
import  'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_bloc.dart';
import  'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_event.dart';
import  'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_state.dart';
import  'package:user_app/features/home/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import  'package:user_app/features/home/presentation/widgets/video_player/pdf_widget.dart';
import  'package:user_app/features/home/presentation/widgets/video_player/video_player.dart';
import 'dart:developer';

class VideoPlayerPage extends StatefulWidget {
  final List<LectureProgressModel> lectures;
  final int currentIndex;
  final String courseId;

  const VideoPlayerPage({
    super.key,
    required this.lectures,
    required this.currentIndex,
    required this.courseId,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late int _currentIndex;
  bool _showNotes = false;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    if (widget.lectures.isNotEmpty && _currentIndex < widget.lectures.length) {
      final lecture = widget.lectures[_currentIndex];
      final userId = context.read<AuthStatusCubit>().state.user?.userId;
      if (lecture.lecture.videoUrl.isNotEmpty && userId != null && widget.courseId.isNotEmpty) {
        try {
          int.parse(_currentIndex.toString());
          log('Initializing video for lecture $_currentIndex: ${lecture.lecture.videoUrl}');
          context.read<VideoPlayerBloc>().add(InitializeVideoEvent(
            videoUrl: lecture.lecture.videoUrl,
            startPosition: lecture.watchedDuration,
            lectureId: _currentIndex.toString(),
            courseId: widget.courseId,
            userId: userId,
          ));
        } catch (e) {
          log('Error: Invalid lecture ID format for index $_currentIndex');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid lecture ID format'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        log('Error: Invalid video URL, user ID, or course ID for lecture $_currentIndex');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid video URL, user not authenticated, or course ID missing'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Updated VideoPlayerPage without additional providers
@override
Widget build(BuildContext context) {
  return Theme(
    data: Theme.of(context).copyWith(
      primaryColor: Colors.deepOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrange,
        brightness: Brightness.light,
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          // Listen to VideoPlayer completion
          BlocListener<VideoPlayerBloc, VideoPlayerState>(
            listenWhen: (previous, current) {
              return current is VideoPlayerReady && 
                     current.isCompleted && 
                     (previous is! VideoPlayerReady || !previous.isCompleted);
            },
            listener: (context, state) {
              if (state is VideoPlayerReady && state.isCompleted) {
                // Refresh course progress when video completes
                final userId = context.read<AuthStatusCubit>().state.user?.userId;
                if (userId != null) {
                  context.read<CourseProgressBloc>().add(
                    RefreshCourseProgressEvent(
                      courseId: widget.courseId,
                      userId: userId,
                    ),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, videoState) {
            if (videoState is VideoPlayerReady && videoState.isFullscreen) {
              return const VideoPlayerWidget();
            }
            return _showNotes ? _buildNotesView() : _buildMainView();
          },
        ),
      ),
    ),
  );
}
  Widget _buildMainView() {
    return Column(
      children: [
        const VideoPlayerWidget(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoInfoSection(),
                if (_isDescriptionExpanded) _buildExpandedDescription(),
                _buildCourseContentList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesView() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showNotes = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.description,
                    color: Colors.deepOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lecture Notes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: PDFViewerWidget(
            pdfUrl: widget.lectures[_currentIndex].lecture.notesUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.lectures[_currentIndex].lecture.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.lectures[_currentIndex].lecture.notesUrl.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showNotes = true;
                    });
                  },
                  icon: const Icon(Icons.description_outlined),
                  color: Colors.deepOrange,
                  tooltip: 'View Notes',
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                icon: Icon(
                  _isDescriptionExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                color: Colors.grey[600],
                tooltip: _isDescriptionExpanded ? 'Collapse' : 'Show Description',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Lecture ${_currentIndex + 1} of ${widget.lectures.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                _formatDuration(Duration(seconds: widget.lectures[_currentIndex].lecture.durationInSeconds)),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                builder: (context, state) {
                  if (state is VideoPlayerReady && state.isCompleted) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.deepOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.lectures[_currentIndex].lecture.description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

 // Updated _buildCourseContentList method
Widget _buildCourseContentList() {
  return BlocBuilder<CourseProgressBloc, CourseProgressState>(
    buildWhen: (previous, current) {
      // Only rebuild when the actual lecture data changes
      if (previous is CourseProgressLoaded && current is CourseProgressLoaded) {
        // Compare lecture completion states
        for (int i = 0; i < previous.courseProgress.lectures.length && 
                     i < current.courseProgress.lectures.length; i++) {
          if (previous.courseProgress.lectures[i].isCompleted != 
              current.courseProgress.lectures[i].isCompleted ||
              previous.courseProgress.lectures[i].isLocked != 
              current.courseProgress.lectures[i].isLocked) {
            return true;
          }
        }
        return false;
      }
      return true;
    },
    builder: (context, progressState) {
      List<LectureProgressModel> lectures = widget.lectures;
      if (progressState is CourseProgressLoaded) {
        lectures = progressState.courseProgress.lectures;
      }

      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Course Content',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[700],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / ${lectures.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lectures.length,
              itemBuilder: (context, index) {
                return _buildLectureItem(index, lectures[index], progressState);
              },
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildLectureItem(int index, LectureProgressModel lecture, CourseProgressState progressState) {
    final isCurrentLecture = index == _currentIndex;
    final isLocked = lecture.isLocked;
    final isCompleted = lecture.isCompleted;

    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          _changeLecture(index);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Complete the previous lecture to unlock this one'),
              backgroundColor: Colors.deepOrange,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentLecture ? Colors.deepOrange[50] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentLecture ? Colors.deepOrange[200]! : Colors.grey[200]!,
            width: isCurrentLecture ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                isLocked
                    ? Icons.lock_outline
                    : isCompleted
                        ? Icons.check_circle
                        : isCurrentLecture
                            ? Icons.play_arrow
                            : Icons.play_circle_outline,
                color: isLocked
                    ? Colors.grey[400]
                    : isCompleted
                        ? Colors.green[600]
                        : Colors.deepOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${lecture.lecture.title}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrentLecture ? FontWeight.w600 : FontWeight.w500,
                      color: isLocked ? Colors.grey[500] : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatDuration(lecture.lecture.duration),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (lecture.progressPercentage > 0 && !isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(lecture.progressPercentage * 100).toInt()}% watched',
                          style: TextStyle(
                            fontSize: 12,
                            color: isCompleted ? Colors.green[600] : Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (lecture.progressPercentage > 0 && !isCompleted && !isLocked) ...[
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: lecture.progressPercentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                      minHeight: 2,
                    ),
                  ],
                ],
              ),
            ),
            if (isCurrentLecture)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _changeLecture(int index) {
    if (index != _currentIndex) {
      context.read<VideoPlayerBloc>().add(DisposeVideoEvent());
      setState(() {
        _currentIndex = index;
        _isDescriptionExpanded = false;
      });
      final lecture = widget.lectures[_currentIndex];
      final userId = context.read<AuthStatusCubit>().state.user?.userId;
      if (lecture.lecture.videoUrl.isNotEmpty && userId != null) {
        try {
          int.parse(_currentIndex.toString());
          context.read<VideoPlayerBloc>().add(InitializeVideoEvent(
            videoUrl: lecture.lecture.videoUrl,
            startPosition: lecture.watchedDuration,
            lectureId: _currentIndex.toString(),
            courseId: widget.courseId,
            userId: userId,
          ));
        } catch (e) {
          log('Error: Invalid lecture ID format for index $_currentIndex');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid lecture ID format'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        log('Error: Invalid video URL or user ID for lecture $_currentIndex');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid video URL or user not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
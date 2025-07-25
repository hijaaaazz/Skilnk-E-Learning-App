// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import '../../../account/presentation/blocs/auth_cubit/auth_cubit.dart';
import '../../data/models/lecture_progress_model.dart';
import '../bloc/progress_bloc/course_progress_bloc.dart';
import '../bloc/progress_bloc/course_progress_event.dart';
import '../bloc/progress_bloc/course_progress_state.dart';
import '../bloc/video_player_bloc/video_player_bloc.dart';
import '../widgets/video_player/pdf_widget.dart';
import '../widgets/video_player/video_player.dart';

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
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.lectures.isNotEmpty && _currentIndex < widget.lectures.length) {
      final lecture = widget.lectures[_currentIndex];
      final userId = context.read<AuthStatusCubit>().state.user?.userId;
      
      if (lecture.lecture.videoUrl.isNotEmpty && userId != null && widget.courseId.isNotEmpty) {
        try {
          context.read<VideoPlayerBloc>().add(InitializeVideoEvent(
            videoUrl: lecture.lecture.videoUrl,
            startPosition: lecture.isCompleted ? Duration.zero : lecture.watchedDuration, // Start from beginning if completed
            lectureId: _currentIndex.toString(),
            courseId: widget.courseId,
            userId: userId,
            wasCompleted: lecture.isCompleted, // Pass completion status
          ));
        } catch (e) {
           SnackBarUtils.showErrorSnackBar(context,"Invalid lecture ID format");
        }
      } else {
        SnackBarUtils.showErrorSnackBar(context,'Invalid video URL or user not authenticated');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VideoPlayerBloc, VideoPlayerState>(
            listenWhen: (previous, current) {
              return current is VideoPlayerReady && current.isCompleted &&
                  (previous is! VideoPlayerReady || !previous.isCompleted);
            },
            listener: (context, state) {
              if (state is VideoPlayerReady && state.isCompleted) {
                final userId = context.read<AuthStatusCubit>().state.user?.userId;
                if (userId != null) {
                  context.read<CourseProgressBloc>().add(
                    RefreshCourseProgressEvent(
                      courseId: widget.courseId,
                      userId: userId,
                    ),
                  );
                }
                
                // Show completion message
                _showCompletionSnackBar();
              }
            },
          ),
        ],
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, videoState) {
            if (videoState is VideoPlayerReady && videoState.isFullscreen) {
              return const VideoPlayerWidget();
            }
            return _showNotes ? _buildNotesView() : _buildMainView(videoState);
          },
        ),
      ),
    );
  }

  void _showCompletionSnackBar() {
    SnackBarUtils.showMinimalSnackBar(context,
              'Lecture completed! Great job!');
  }

  Widget _buildMainView(VideoPlayerState videoState) {
    return Column(
      children: [
        // Video Player Container
        Container(
          color: Colors.black,
          child: videoState is VideoPlayerLoading 
              ? _buildVideoLoadingState()
              : const VideoPlayerWidget(),
        ),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoInfoSection(videoState),
                if (_isDescriptionExpanded) _buildExpandedDescription(),
                _buildCourseContentList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoLoadingState() {
    return Container(
      height: 220,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFFFF6B35).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B35),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesView() {
    return Column(
      children: [
        // Modern Notes Header
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showNotes = false;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF1A1A1A),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Color(0xFFFF6B35),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Lecture Notes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // PDF Viewer
        Expanded(
          child: PDFViewerWidget(
            pdfUrl: widget.lectures[_currentIndex].lecture.notesUrl,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoInfoSection(VideoPlayerState videoState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Actions Row
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.lectures[_currentIndex].lecture.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              
              // Replay Button (for completed videos)
              if (videoState is VideoPlayerReady && videoState.isCompleted)
                _buildActionButton(
                  icon: Icons.replay,
                  onTap: () {
                    context.read<VideoPlayerBloc>().add(ReplayVideoEvent());
                  },
                  tooltip: 'Replay Video',
                  isHighlighted: true,
                ),
              
              // Notes Button
              if (widget.lectures[_currentIndex].lecture.notesUrl.isNotEmpty) ...[
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.description_outlined,
                  onTap: () {
                    setState(() {
                      _showNotes = true;
                    });
                  },
                  tooltip: 'View Notes',
                ),
              ],
              
              const SizedBox(width: 8),
              
              // Expand Description Button
              _buildActionButton(
                icon: _isDescriptionExpanded ? Icons.expand_less : Icons.expand_more,
                onTap: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                tooltip: _isDescriptionExpanded ? 'Collapse' : 'Show Description',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Lecture Info Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lecture ${_currentIndex + 1} of ${widget.lectures.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.access_time,
                size: 16,
                color: const Color(0xFF666666).withOpacity(0.7),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDuration(Duration(
                  seconds: widget.lectures[_currentIndex].lecture.durationInSeconds,
                )),
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF666666).withOpacity(0.7),
                ),
              ),
              const Spacer(),
              
              // Video Status Indicator
              _buildVideoStatusIndicator(videoState),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoStatusIndicator(VideoPlayerState videoState) {
    if (videoState is VideoPlayerReady) {
      if (videoState.isCompleted) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                'COMPLETED',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      } else if (videoState.isPlaying) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                color: Color(0xFFFF6B35),
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                'PLAYING',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF666666).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pause,
                color: Color(0xFF666666),
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                'PAUSED',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isHighlighted 
              ? const Color(0xFFFF6B35).withOpacity(0.1)
              : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isHighlighted 
              ? const Color(0xFFFF6B35)
              : const Color(0xFF666666),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildExpandedDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFFF6B35),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.lectures[_currentIndex].lecture.description,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContentList() {
    return BlocBuilder<CourseProgressBloc, CourseProgressState>(
      buildWhen: (previous, current) {
        if (previous is CourseProgressLoaded && current is CourseProgressLoaded) {
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Course Content',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${lectures.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lecture List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lectures.length,
                itemBuilder: (context, index) {
                  return _buildLectureItem(index, lectures[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLectureItem(int index, LectureProgressModel lecture) {
    final isCurrentLecture = index == _currentIndex;
    final isLocked = lecture.isLocked;
    final isCompleted = lecture.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentLecture 
            ? const Color(0xFFFF6B35).withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentLecture 
              ? const Color(0xFFFF6B35).withOpacity(0.3)
              : const Color(0xFFF0F0F0),
          width: isCurrentLecture ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isLocked) {
              _changeLecture(index);
            } else {
              SnackBarUtils.showMinimalSnackBar(context,'Complete the previous lecture to unlock this one');
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Thumbnail/Status Icon
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(isLocked, isCompleted, isCurrentLecture)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(isLocked, isCompleted, isCurrentLecture),
                    color: _getStatusColor(isLocked, isCompleted, isCurrentLecture),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${lecture.lecture.title}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCurrentLecture ? FontWeight.w600 : FontWeight.w500,
                          color: isLocked 
                              ? const Color(0xFF999999)
                              : const Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: const Color(0xFF666666).withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(lecture.lecture.duration),
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF666666).withOpacity(0.7),
                            ),
                          ),
                          if (lecture.progressPercentage > 0 && !isLocked && !isCompleted) ...[
                            const SizedBox(width: 12),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF666666).withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(lecture.progressPercentage * 100).toInt()}% watched',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF6B35),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (isCompleted) ...[
                            const SizedBox(width: 12),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFF666666).withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      // Progress Bar (only for in-progress lectures)
                      if (lecture.progressPercentage > 0 && !isCompleted && !isLocked) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: lecture.progressPercentage,
                          backgroundColor: const Color(0xFFF0F0F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Current Lecture Badge
                if (isCurrentLecture)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(bool isLocked, bool isCompleted, bool isCurrentLecture) {
    if (isLocked) return const Color(0xFF999999);
    if (isCompleted) return const Color(0xFF4CAF50);
    if (isCurrentLecture) return const Color(0xFFFF6B35);
    return const Color(0xFF666666);
  }

  IconData _getStatusIcon(bool isLocked, bool isCompleted, bool isCurrentLecture) {
    if (isLocked) return Icons.lock_outline;
    if (isCompleted) return Icons.check_circle;
    if (isCurrentLecture) return Icons.play_arrow;
    return Icons.play_circle_outline;
  }

  void _changeLecture(int index) {
    if (index != _currentIndex) {
      context.read<VideoPlayerBloc>().add(DisposeVideoEvent());
      
      setState(() {
        _currentIndex = index;
        _isDescriptionExpanded = false;
      });
      
      _initializeVideo();
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

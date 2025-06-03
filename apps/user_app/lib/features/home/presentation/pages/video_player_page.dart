import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_app/features/home/domain/entity/lecture_details.dart';
import 'package:user_app/features/home/presentation/widgets/download_progress_dialog.dart';
import 'package:user_app/features/home/presentation/widgets/lecture_note_sheets.dart';
import 'package:user_app/features/home/presentation/widgets/video_controllers.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoPlayerPage extends StatefulWidget {
  final String lectureId;
  final String courseId;

  const VideoPlayerPage({
    super.key,
    required this.lectureId,
    required this.courseId,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  LectureDetail? lectureDetail;
  bool isLoading = true;
  bool isFullScreen = false;
  bool showControls = true;
  bool isBuffering = false;
  Timer? _hideControlsTimer;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  @override
  void initState() {
    super.initState();
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    ));
    _loadLectureDetail();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _hideControlsTimer?.cancel();
    _controlsAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadLectureDetail() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    final mockLectureDetail = LectureDetail(
      id: widget.lectureId,
      title: 'Introduction to Flutter Development',
      description: 'Learn the basics of Flutter development including widgets, layouts, and state management. This comprehensive introduction will give you a solid foundation to build amazing mobile applications.',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      notesUrl: 'https://example.com/notes.pdf',
      duration: const Duration(minutes: 15, seconds: 30),
      lectureNumber: 1,
      courseId: widget.courseId,
      courseTitle: 'Complete Flutter Development Course',
      hasNextLecture: true,
      hasPreviousLecture: false,
      nextLectureId: '2',
      notes: [
        LectureNote(
          id: '1',
          title: 'Flutter Overview',
          content: 'Flutter is Google\'s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        LectureNote(
          id: '2',
          title: 'Key Concepts',
          content: 'Everything in Flutter is a widget. Widgets describe what their view should look like given their current configuration and state.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
      isDownloadable: true,
      isDownloaded: false,
    );

    setState(() {
      lectureDetail = mockLectureDetail;
      isLoading = false;
    });

    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (lectureDetail?.videoUrl != null) {
      _videoController = VideoPlayerController.network(lectureDetail!.videoUrl);
      
      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            isBuffering = _videoController!.value.isBuffering;
          });
        }
      });

      try {
        await _videoController!.initialize();
        setState(() {});
        _showControlsTemporarily();
      } catch (e) {
        _showErrorSnackBar('Failed to load video');
      }
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      showControls = true;
    });
    _controlsAnimationController.forward();
    
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _videoController?.value.isPlaying == true) {
        _hideControls();
      }
    });
  }

  void _hideControls() {
    _controlsAnimationController.reverse();
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _showNotesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LectureNotesSheet(
        notes: lectureDetail?.notes ?? [],
        lectureTitle: lectureDetail?.title ?? '',
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => DownloadProgressDialog(
        lectureTitle: lectureDetail?.title ?? '',
        onDownloadComplete: () {
          setState(() {
            // Update download status
          });
        },
      ),
    );
  }

  void _navigateToNextLecture() {
    if (lectureDetail?.hasNextLecture == true && lectureDetail?.nextLectureId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            lectureId: lectureDetail!.nextLectureId!,
            courseId: widget.courseId,
          ),
        ),
      );
    }
  }

  void _navigateToPreviousLecture() {
    if (lectureDetail?.hasPreviousLecture == true && lectureDetail?.previousLectureId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            lectureId: lectureDetail!.previousLectureId!,
            courseId: widget.courseId,
          ),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6636),
          ),
        ),
      );
    }

    if (isFullScreen) {
      return _buildFullScreenPlayer();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildVideoPlayer(),
          Expanded(
            child: _buildLectureDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _videoController?.value.isInitialized == true
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : const CircularProgressIndicator(color: Color(0xFFFF6636)),
          ),
          if (isBuffering)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6636),
              ),
            ),
          if (showControls)
            AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _controlsAnimation.value,
                  child: VideoControls(
                    controller: _videoController,
                    isFullScreen: isFullScreen,
                    onFullScreenToggle: _toggleFullScreen,
                    onNext: lectureDetail?.hasNextLecture == true ? _navigateToNextLecture : null,
                    onPrevious: lectureDetail?.hasPreviousLecture == true ? _navigateToPreviousLecture : null,
                  ),
                );
              },
            ),
          GestureDetector(
            onTap: _showControlsTemporarily,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.black,
      child: Stack(
        children: [
          if (_videoController?.value.isInitialized == true)
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6636),
              ),
            ),
          
          if (isBuffering)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6636),
              ),
            ),

          if (showControls)
            AnimatedBuilder(
              animation: _controlsAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _controlsAnimation.value,
                  child: VideoControls(
                    controller: _videoController,
                    isFullScreen: isFullScreen,
                    onFullScreenToggle: _toggleFullScreen,
                    onNext: lectureDetail?.hasNextLecture == true ? _navigateToNextLecture : null,
                    onPrevious: lectureDetail?.hasPreviousLecture == true ? _navigateToPreviousLecture : null,
                  ),
                );
              },
            ),

          GestureDetector(
            onTap: _showControlsTemporarily,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLectureDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLectureHeader(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 24),
          _buildDescription(),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildLectureHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lecture ${lectureDetail?.lectureNumber}',
          style: const TextStyle(
            color: Color(0xFFFF6636),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lectureDetail?.title ?? '',
          style: const TextStyle(
            color: Color(0xFF202244),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lectureDetail?.courseTitle ?? '',
          style: const TextStyle(
            color: Color(0xFF545454),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.note_alt_outlined,
            label: 'Notes',
            onTap: _showNotesSheet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: lectureDetail?.isDownloaded == true 
                ? Icons.download_done 
                : Icons.download_outlined,
            label: lectureDetail?.isDownloaded == true ? 'Downloaded' : 'Download',
            onTap: lectureDetail?.isDownloaded == true ? null : _showDownloadDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF0F0F0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDisabled ? const Color(0xFFE0E0E0) : const Color(0xFFFF6636),
            width: 1.5,
          ),
          boxShadow: isDisabled ? null : [
            BoxShadow(
              color: const Color(0xFFFF6636).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDisabled ? const Color(0xFF9E9E9E) : const Color(0xFFFF6636),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDisabled ? const Color(0xFF9E9E9E) : const Color(0xFFFF6636),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this lecture',
          style: TextStyle(
            color: Color(0xFF202244),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          lectureDetail?.description ?? '',
          style: const TextStyle(
            color: Color(0xFF545454),
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        if (lectureDetail?.hasPreviousLecture == true)
          _buildNavigationButton(
            icon: Icons.skip_previous,
            label: 'Previous Lecture',
            onTap: _navigateToPreviousLecture,
            isPrimary: false,
          ),
        
        if (lectureDetail?.hasPreviousLecture == true && lectureDetail?.hasNextLecture == true)
          const SizedBox(height: 12),
        
        if (lectureDetail?.hasNextLecture == true)
          _buildNavigationButton(
            icon: Icons.skip_next,
            label: 'Next Lecture',
            onTap: _navigateToNextLecture,
            isPrimary: true,
          ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFFFF6636),
          size: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isPrimary ? Colors.white : const Color(0xFFFF6636),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFFFF6636) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFFFF6636),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFFFF6636),
              width: isPrimary ? 0 : 1.5,
            ),
          ),
          elevation: isPrimary ? 4 : 0,
          shadowColor: isPrimary ? const Color(0xFFFF6636).withOpacity(0.3) : null,
        ),
      ),
    );
  }
}
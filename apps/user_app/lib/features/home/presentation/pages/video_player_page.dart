import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'package:user_app/features/home/domain/entity/lecture_entity.dart';
import 'package:user_app/features/home/presentation/widgets/download_progress_dialog.dart';
import 'package:user_app/features/home/presentation/widgets/video_controllers.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final List<LectureProgressModel> lectures;
  final int currentIndex;

  const VideoPlayerPage({
    super.key,
    required this.lectures,
    required this.currentIndex,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool isLoading = true;
  bool isFullScreen = false;
  bool showControls = true;
  bool isBuffering = false;
  Timer? _hideControlsTimer;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;
  late int currentIndex;

  LectureProgressModel get currentLecture => widget.lectures[currentIndex];
  bool get hasNextLecture => currentIndex < widget.lectures.length - 1;
  bool get hasPreviousLecture => currentIndex > 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
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
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _hideControlsTimer?.cancel();
    _controlsAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    setState(() {
      isLoading = true;
    });

    // Dispose previous controller if exists
    await _videoController?.dispose();

    if (currentLecture.lecture.videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(currentLecture.lecture.videoUrl));
      
      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            isBuffering = _videoController!.value.isBuffering;
          });
        }
      });

      try {
        await _videoController!.initialize();
        setState(() {
          isLoading = false;
        });
        _showControlsTemporarily();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Failed to load video');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Video URL not available');
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
    _openPdfNotes(currentLecture.lecture.notesUrl);
  }

  Future<void> _openPdfNotes(String pdfUrl) async {
    if (pdfUrl.isEmpty) {
      _showErrorSnackBar('PDF URL not available');
      return;
    }

    final Uri uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open PDF');
    }
  }

  Future<void> _showDownloadDialog() async {
    // Request storage permission for Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        _showErrorSnackBar('Storage permission denied');
        return;
      }
    }

    // Initialize download
    final String pdfUrl = currentLecture.lecture.notesUrl;
    if (pdfUrl.isEmpty) {
      _showErrorSnackBar('PDF URL not available');
      return;
    }

    try {
      final String fileName = 'lecture_${currentIndex + 1}_${currentLecture.lecture.title}.pdf';
      final String? taskId = await FlutterDownloader.enqueue(
        url: pdfUrl,
        savedDir: '/storage/emulated/0/Download', // Android default download directory
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId != null) {
        showDialog(
          context: context,
          builder: (context) => DownloadProgressDialog(
            lectureTitle: currentLecture.lecture.title,
            onDownloadComplete: () {
              setState(() {
                // Update download status if needed
              });
              _showErrorSnackBar('Download completed: $fileName');
            },
          ),
        );
      } else {
        _showErrorSnackBar('Failed to start download');
      }
    } catch (e) {
      _showErrorSnackBar('Download error: $e');
    }
  }

  void _navigateToNextLecture() {
    if (hasNextLecture) {
      setState(() {
        currentIndex++;
      });
      _initializeVideoPlayer();
    }
  }

  void _navigateToPreviousLecture() {
    if (hasPreviousLecture) {
      setState(() {
        currentIndex--;
      });
      _initializeVideoPlayer();
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
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
                    onNext: hasNextLecture ? _navigateToNextLecture : null,
                    onPrevious: hasPreviousLecture ? _navigateToPreviousLecture : null,
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
                    onNext: hasNextLecture ? _navigateToNextLecture : null,
                    onPrevious: hasPreviousLecture ? _navigateToPreviousLecture : null,
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
          'Lecture ${currentIndex + 1}',
          style: const TextStyle(
            color: Color(0xFFFF6636),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          currentLecture.lecture.title,
          style: const TextStyle(
            color: Color(0xFF202244),
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 16,
              color: Color(0xFF545454),
            ),
            const SizedBox(width: 4),
            Text(
              _formatDuration(currentLecture.lecture.duration),
              style: const TextStyle(
                color: Color(0xFF545454),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${currentIndex + 1} of ${widget.lectures.length}',
              style: const TextStyle(
                color: Color(0xFF545454),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.picture_as_pdf,
            label: 'PDF Notes',
            onTap: _showNotesSheet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.download_outlined,
            label: 'Download',
            onTap: _showDownloadDialog,
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
          currentLecture.lecture.description,
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
        if (hasPreviousLecture)
          _buildNavigationButton(
            icon: Icons.skip_previous,
            label: 'Previous Lecture',
            onTap: _navigateToPreviousLecture,
            isPrimary: false,
          ),
        
        if (hasPreviousLecture && hasNextLecture)
          const SizedBox(height: 12),
        
        if (hasNextLecture)
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
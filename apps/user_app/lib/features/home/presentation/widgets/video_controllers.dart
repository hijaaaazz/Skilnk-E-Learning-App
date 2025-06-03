import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  final VideoPlayerController? controller;
  final bool isFullScreen;
  final VoidCallback onFullScreenToggle;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const VideoControls({
    super.key,
    required this.controller,
    required this.isFullScreen,
    required this.onFullScreenToggle,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller?.value.isInitialized != true) {
      return const SizedBox.shrink();
    }

    final controller = widget.controller!;
    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          // Top controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (widget.isFullScreen) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ],
            ),
          ),

          const Spacer(),

          // Center controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.onPrevious != null)
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: widget.onPrevious,
                ),
              
              const SizedBox(width: 20),
              
              // Play/Pause button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6636),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6636).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    });
                  },
                ),
              ),
              
              const SizedBox(width: 20),
              
              if (widget.onNext != null)
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: widget.onNext,
                ),
            ],
          ),

          const Spacer(),

          // Bottom controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress bar
                Row(
                  children: [
                    Text(
                      _formatDuration(position),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFFFF6636),
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: const Color(0xFFFF6636),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 12,
                          ),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: progress.clamp(0.0, 1.0),
                          onChanged: (value) {
                            final newPosition = Duration(
                              milliseconds: (value * duration.inMilliseconds).round(),
                            );
                            controller.seekTo(newPosition);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            final newPosition = position - const Duration(seconds: 10);
                            controller.seekTo(newPosition);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            final newPosition = position + const Duration(seconds: 10);
                            controller.seekTo(newPosition);
                          },
                        ),
                      ],
                    ),
                    
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            // Show quality/speed settings
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isFullScreen 
                                ? Icons.fullscreen_exit 
                                : Icons.fullscreen,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: widget.onFullScreenToggle,
                        ),
                      ],
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
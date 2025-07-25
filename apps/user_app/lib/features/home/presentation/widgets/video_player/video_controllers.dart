// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/video_player_bloc/video_player_bloc.dart';
import 'dart:developer';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      builder: (context, state) {
        if (state is! VideoPlayerReady) {
          return const SizedBox.shrink();
        }

        return AnimatedOpacity(
          opacity: state.showControls ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Back button for fullscreen
                if (state.isFullscreen)
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    child: _buildModernControlButton(
                      icon: Icons.arrow_back_ios,
                      onPressed: () {
                        log('Exiting fullscreen via back button');
                        context.read<VideoPlayerBloc>().add(ToggleFullscreenEvent());
                      },
                    ),
                  ),

                // Center play/pause button (make smaller)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      log('Toggling play/pause');
                      context.read<VideoPlayerBloc>().add(TogglePlayPauseEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16), // Reduced from 20
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32, // Reduced from 40
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Top controls
                Positioned(
                  top: state.isFullscreen ? MediaQuery.of(context).padding.top + 8 : 8,
                  left: state.isFullscreen ? 80 : 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpeedButton(context, state),
                      _buildTimeDisplay(state),
                    ],
                  ),
                ),

                // Bottom controls (reordered)
                Positioned(
                  bottom: state.isFullscreen ? MediaQuery.of(context).padding.bottom + 8 : 8,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Control buttons first
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildModernControlButton(
                                icon: Icons.replay_10,
                                onPressed: () {
                                  final newPosition = state.position - const Duration(seconds: 10);
                                  log('Rewinding to: $newPosition');
                                  context.read<VideoPlayerBloc>().add(
                                    SeekVideoEvent(newPosition < Duration.zero ? Duration.zero : newPosition),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildModernControlButton(
                                icon: Icons.forward_10,
                                onPressed: () {
                                  final newPosition = state.position + const Duration(seconds: 10);
                                  log('Forwarding to: $newPosition');
                                  context.read<VideoPlayerBloc>().add(
                                    SeekVideoEvent(newPosition > state.duration ? state.duration : newPosition),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildModernControlButton(
                            icon: state.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                            onPressed: () {
                              log('Toggling fullscreen');
                              context.read<VideoPlayerBloc>().add(ToggleFullscreenEvent());
                            },
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16), // Space between buttons and progress bar
                      
                      // Progress bar below buttons
                      _buildProgressBar(context, state),
                    ],
                  ),
                ),

                // Completion indicator
                if (state.isCompleted)
                  Positioned(
                    top: state.isFullscreen ? MediaQuery.of(context).padding.top + 60 : 60,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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
      },
    );
  }

  Widget _buildProgressBar(BuildContext context, VideoPlayerReady state) {
    return SizedBox(
      height: 40, // Increased height for better touch target
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: AppColors.primaryOrange,
          inactiveTrackColor: Colors.white.withOpacity(0.3),
          thumbColor: AppColors.primaryOrange,
          overlayColor: AppColors.primaryOrange.withOpacity(0.3),
        ),
        child: Slider(
          value: state.progress.clamp(0.0, 1.0),
          onChanged: (value) {
            final newPosition = state.duration * value;
            log('Seeking to: $newPosition');
            context.read<VideoPlayerBloc>().add(SeekVideoEvent(newPosition));
          },
          onChangeStart: (value) {
            // Pause auto-hide when user starts seeking
            context.read<VideoPlayerBloc>().add(ShowControlsEvent());
          },
          onChangeEnd: (value) {
            // Resume auto-hide after seeking
            context.read<VideoPlayerBloc>().add(ShowControlsEvent());
          },
        ),
      ),
    );
  }

  Widget _buildModernControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSpeedButton(BuildContext context, VideoPlayerReady state) {
    return Row(
      children: [
        if (!state.isFullscreen)
          _buildModernControlButton(
            icon: Icons.arrow_back_ios,
            onPressed: () {
              context.pop();
            },
          ),
        const SizedBox(width: 12),
        PopupMenuButton<double>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              '${state.playbackSpeed}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          itemBuilder: (context) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
            return PopupMenuItem<double>(
              value: speed,
              child: Row(
                children: [
                  Text('${speed}x'),
                  if (speed == state.playbackSpeed) ...[
                    const Spacer(),
                    const Icon(
                      Icons.check,
                      color: AppColors.primaryOrange,
                      size: 16,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onSelected: (speed) {
            log('Changing playback speed to: ${speed}x');
            context.read<VideoPlayerBloc>().add(ChangePlaybackSpeedEvent(speed));
          },
        ),
      ],
    );
  }

  Widget _buildTimeDisplay(VideoPlayerReady state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        '${_formatDuration(state.position)} / ${_formatDuration(state.duration)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/video_player_bloc.dart';
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
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                      onPressed: () {
                        log('Exiting fullscreen via back button');
                        context.read<VideoPlayerBloc>().add(ToggleFullscreenEvent());
                      },
                    ),
                  ),

                // Center play/pause button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      log('Toggling play/pause');
                      context.read<VideoPlayerBloc>().add(TogglePlayPauseEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 36,
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

                // Bottom controls
                Positioned(
                  bottom: state.isFullscreen ? MediaQuery.of(context).padding.bottom + 8 : 8,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Progress bar
                      
                      
                      // Control buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildControlButton(
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
                              _buildControlButton(
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
                          _buildControlButton(
                            icon: state.isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                            onPressed: () {
                              log('Toggling fullscreen');
                              context.read<VideoPlayerBloc>().add(ToggleFullscreenEvent());
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: _buildProgressBar(context, state)),
                    ],
                  ),
                ),

                // Completion indicator
                if (state.isCompleted)
                  Positioned(
                    top: state.isFullscreen ? MediaQuery.of(context).padding.top + 60 : 60,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
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
                              fontWeight: FontWeight.bold,
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
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localOffset = box.globalToLocal(details.globalPosition);
          final progress = (localOffset.dx / box.size.width).clamp(0.0, 1.0);
          final newPosition = state.duration * progress;
          log('Dragging progress bar to: $newPosition');
          context.read<VideoPlayerBloc>().add(SeekVideoEvent(newPosition));
        }
      },
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localOffset = box.globalToLocal(details.globalPosition);
          final progress = (localOffset.dx / box.size.width).clamp(0.0, 1.0);
          final newPosition = state.duration * progress;
          log('Tapped progress bar at: $newPosition');
          context.read<VideoPlayerBloc>().add(SeekVideoEvent(newPosition));
        }
      },
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: state.completionProgress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: state.progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildSpeedButton(BuildContext context, VideoPlayerReady state) {
    return Row(
      children: [
        !state.isFullscreen?
        IconButton(
          onPressed: (){
            context.pop();
          },
          icon:  Icon(Icons.arrow_back_ios,color: Colors.white,)): SizedBox.shrink(),
        PopupMenuButton<double>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(6),
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
          itemBuilder: (context) => [
            0.5,
            0.75,
            1.0,
            1.25,
            1.5,
            2.0,
          ].map((speed) {
            return PopupMenuItem<double>(
              value: speed,
              child: Text('${speed}x'),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
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

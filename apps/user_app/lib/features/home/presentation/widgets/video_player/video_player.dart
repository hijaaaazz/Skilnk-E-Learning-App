import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import  'package:user_app/features/home/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import  'package:user_app/features/home/presentation/widgets/video_player/video_controllers.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      buildWhen: (previous, current) {
        if (previous.runtimeType != current.runtimeType) return true;
        if (current is VideoPlayerReady && previous is VideoPlayerReady) {
          return previous.isFullscreen != current.isFullscreen ||
                 previous.isBuffering != current.isBuffering ||
                 previous.isCompleted != current.isCompleted ||
                 previous.isPlaying != current.isPlaying ||
                 previous.controller != current.controller;
        }
        return true;
      },
      builder: (context, state) {
        if (state is VideoPlayerReady && state.isFullscreen) {
          return _buildFullscreenPlayer(state, context);
        }
        
        return Container(
          color: Colors.black,
          child: SafeArea(
            top: true,
            bottom: false,
            child: _buildVideoContent(state, context),
          ),
        );
      },
    );
  }

  Widget _buildVideoContent(VideoPlayerState state, BuildContext context) {
    if (state is VideoPlayerLoading) {
      return _buildLoadingState();
    }

    if (state is VideoPlayerError) {
      return _buildErrorState(state, context);
    }

    if (state is VideoPlayerReady) {
      return _buildNormalVideoPlayer(state, context);
    }

    return _buildInitialState();
  }

  Widget _buildLoadingState() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.deepOrange,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(VideoPlayerError state, BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.deepOrange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please go back and try again'),
                        backgroundColor: Colors.deepOrange,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNormalVideoPlayer(VideoPlayerReady state, BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GestureDetector(
        onTap: () {
          context.read<VideoPlayerBloc>().add(ShowControlsEvent());
        },
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: state.controller.value.aspectRatio,
                child: VideoPlayer(state.controller),
              ),
            ),
            
            // Fixed buffering indicator
            if (state.isBuffering && 
                state.controller.value.isInitialized && 
                !state.isCompleted)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                    strokeWidth: 3,
                  ),
                ),
              ),
            
            // 🔧 FIXED: Show completion overlay only when completed AND not playing
            if (state.isCompleted && !state.isPlaying)
              _buildCompletionOverlay(context, state),
            
            // Video Controls - show when not completed OR when playing after completion
            if (!state.isCompleted || state.isPlaying)
              const VideoControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenPlayer(VideoPlayerReady state, BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          context.read<VideoPlayerBloc>().add(ShowControlsEvent());
        },
        child: Stack(
          children: [
            // Full screen video player
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: state.controller.value.size.width,
                    height: state.controller.value.size.height,
                    child: VideoPlayer(state.controller),
                  ),
                ),
              ),
            ),
            
            // Fixed buffering indicator for fullscreen
            if (state.isBuffering && 
                state.controller.value.isInitialized && 
                !state.isCompleted)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                    strokeWidth: 3,
                  ),
                ),
              ),
            
            // 🔧 FIXED: Fullscreen completion overlay
            if (state.isCompleted && !state.isPlaying)
              _buildCompletionOverlay(context, state),
            
            // Video Controls
            if (!state.isCompleted || state.isPlaying)
              const VideoControls(),
          ],
        ),
      ),
    );
  }

  // 🔧 IMPROVED: Better replay functionality
  Widget _buildCompletionOverlay(BuildContext context, VideoPlayerReady state) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Completion badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // 🔧 IMPROVED: Better replay button logic
            GestureDetector(
              onTap: () {
                // Method 1: Use ReplayVideoEvent (if you added it to bloc)
                // context.read<VideoPlayerBloc>().add(ReplayVideoEvent());
                
                // Method 2: Sequential events (current approach but improved)
                context.read<VideoPlayerBloc>().add(
                  SeekVideoEvent(Duration.zero),
                );
                // Small delay to ensure seek completes
                Future.delayed(const Duration(milliseconds: 100), () {
                  context.read<VideoPlayerBloc>().add(PlayVideoEvent());
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.replay,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap to replay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Colors.deepOrange,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Ready to play',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
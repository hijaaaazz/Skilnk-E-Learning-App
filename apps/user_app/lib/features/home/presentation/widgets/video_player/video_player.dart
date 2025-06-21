import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/video_player_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/video_player/video_controllers.dart';

import 'package:video_player/video_player.dart';


class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
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
                Icon(
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
                    context.read<VideoPlayerBloc>().add(
                      InitializeVideoEvent(videoUrl: state.videoUrl),
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
                child: Positioned.fill(
                  child: VideoPlayer(state.controller),
                ),
              ),
            ),
            
            // Buffering Indicator
            if (state.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                  strokeWidth: 3,
                ),
              ),
            
            // Video Controls
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
            
            // Buffering Indicator
            if (state.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                  strokeWidth: 3,
                ),
              ),
            
            // Video Controls
            const VideoControls(),
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

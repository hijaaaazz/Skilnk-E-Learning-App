// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../bloc/video_player_bloc/video_player_bloc.dart';
import 'video_controllers.dart';
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
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
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: AppColors.primaryOrange,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Error loading video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
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
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    SnackBarUtils.showMinimalSnackBar(context,'Please go back and try again');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

            // Modern buffering indicator
            if (state.isBuffering && state.controller.value.isInitialized && !state.isCompleted)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              ),

            // Completion overlay
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

            // Fullscreen buffering indicator
            if (state.isBuffering && state.controller.value.isInitialized && !state.isCompleted)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                ),
              ),

            // Fullscreen completion overlay
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

  Widget _buildCompletionOverlay(BuildContext context, VideoPlayerReady state) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern completion badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'LECTURE COMPLETED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Modern replay button
            GestureDetector(
              onTap: () {
                context.read<VideoPlayerBloc>().add(ReplayVideoEvent());
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.replay,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap to replay',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.primaryOrange,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ready to play',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

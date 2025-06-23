part of 'video_player_bloc.dart';

abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object?> get props => [];
}

class VideoPlayerInitial extends VideoPlayerState {}

class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerReady extends VideoPlayerState {
  final VideoPlayerController controller;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final bool isFullscreen;
  final bool showControls;
  final bool isBuffering;
  final double playbackSpeed;
  final String videoUrl;
  final Duration watchedDuration;
  final bool isCompleted;

  const VideoPlayerReady({
    required this.controller,
    required this.duration,
    required this.position,
    required this.videoUrl,
    this.isPlaying = false,
    this.isFullscreen = false,
    this.showControls = true,
    this.isBuffering = false,
    this.playbackSpeed = 1.0,
    this.watchedDuration = Duration.zero,
    this.isCompleted = false,
  });

  double get progress => duration.inMilliseconds > 0 ? position.inMilliseconds / duration.inMilliseconds : 0.0;
  
  double get completionProgress => duration.inMilliseconds > 0 ? watchedDuration.inMilliseconds / duration.inMilliseconds : 0.0;

  VideoPlayerReady copyWith({
    VideoPlayerController? controller,
    Duration? duration,
    Duration? position,
    bool? isPlaying,
    bool? isFullscreen,
    bool? showControls,
    bool? isBuffering,
    double? playbackSpeed,
    String? videoUrl,
    Duration? watchedDuration,
    bool? isCompleted,
  }) {
    return VideoPlayerReady(
      controller: controller ?? this.controller,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      showControls: showControls ?? this.showControls,
      isBuffering: isBuffering ?? this.isBuffering,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      videoUrl: videoUrl ?? this.videoUrl,
      watchedDuration: watchedDuration ?? this.watchedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        controller,
        duration,
        position,
        isPlaying,
        isFullscreen,
        showControls,
        isBuffering,
        playbackSpeed,
        videoUrl,
        watchedDuration,
        isCompleted,
      ];
}

class VideoPlayerError extends VideoPlayerState {
  final String message;
  final String videoUrl;

  const VideoPlayerError(this.message, {required this.videoUrl});

  @override
  List<Object?> get props => [message, videoUrl];
}

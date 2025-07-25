part of 'video_player_bloc.dart';

@immutable
abstract class VideoPlayerEvent {}

class InitializeVideoEvent extends VideoPlayerEvent {
  final String videoUrl;
  final Duration? startPosition;
  final String? lectureId;
  final String? courseId;
  final String? userId;
  final bool? wasCompleted; // Add this to track if lecture was previously completed

  InitializeVideoEvent({
    required this.videoUrl,
    this.startPosition = Duration.zero,
    required this.lectureId,
    required this.courseId,
    required this.userId,
    this.wasCompleted = false,
  });
}

class PlayVideoEvent extends VideoPlayerEvent {}

class PauseVideoEvent extends VideoPlayerEvent {}

class TogglePlayPauseEvent extends VideoPlayerEvent {}

class SeekVideoEvent extends VideoPlayerEvent {
  final Duration position;
  SeekVideoEvent(this.position);
}

class ToggleFullscreenEvent extends VideoPlayerEvent {}

class ShowControlsEvent extends VideoPlayerEvent {}

class HideControlsEvent extends VideoPlayerEvent {}

class UpdateProgressEvent extends VideoPlayerEvent {
  final Duration position;
  final Duration duration;
  
  UpdateProgressEvent({
    required this.position, 
    required this.duration
  });
}

class ChangePlaybackSpeedEvent extends VideoPlayerEvent {
  final double speed;
  ChangePlaybackSpeedEvent(this.speed);
}

class DisposeVideoEvent extends VideoPlayerEvent {}

class VideoCompletedEvent extends VideoPlayerEvent {
  final String lectureId;
  final String courseId;
  final String userId;

  VideoCompletedEvent({
    required this.lectureId,
    required this.courseId,
    required this.userId,
  });
}

class ReplayVideoEvent extends VideoPlayerEvent {}

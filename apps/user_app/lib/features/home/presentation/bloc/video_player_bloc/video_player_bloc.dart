import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import  'package:user_app/features/home/data/models/update_progress_params.dart';
import  'package:user_app/features/home/domain/usecases/udpate_course_progress.dart';
import  'package:user_app/service_locator.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerController? _controller;
  Timer? _hideControlsTimer;
  Timer? _progressTimer;
  String? _currentVideoUrl;
  Duration _totalWatchedDuration = Duration.zero;
  Duration _lastPosition = Duration.zero;
  String? _lectureId;
  String? _courseId;
  String? _userId;

  VideoPlayerBloc() : super(VideoPlayerInitial()) {
    on<InitializeVideoEvent>(_onInitializeVideo);
    on<PlayVideoEvent>(_onPlayVideo);
    on<PauseVideoEvent>(_onPauseVideo);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
    on<SeekVideoEvent>(_onSeekVideo);
    on<ToggleFullscreenEvent>(_onToggleFullscreen);
    on<ShowControlsEvent>(_onShowControls);
    on<HideControlsEvent>(_onHideControls);
    on<UpdateProgressEvent>(_onUpdateProgress);
    on<ChangePlaybackSpeedEvent>(_onChangePlaybackSpeed);
    on<DisposeVideoEvent>(_onDisposeVideo);
    on<VideoCompletedEvent>(_onVideoCompleted);
     on<ReplayVideoEvent>(_onReplayVideo);
  }

  Future<void> _onInitializeVideo(InitializeVideoEvent event, Emitter<VideoPlayerState> emit) async {
    try {
      if (event.videoUrl.isEmpty || !Uri.parse(event.videoUrl).isAbsolute) {
        throw Exception('Invalid video URL');
      }
      if (event.lectureId == null || event.courseId == null || event.userId == null) {
        throw Exception('Lecture ID, Course ID, or User ID cannot be null');
      }

      emit(VideoPlayerLoading());
      log('Initializing video: ${event.videoUrl}');
      _currentVideoUrl = event.videoUrl;
      _totalWatchedDuration = event.startPosition ?? Duration.zero;
      _lectureId = event.lectureId;
      _courseId = event.courseId;
      _userId = event.userId;

      // Dispose old controller
      await _controller?.dispose();
      _controller = null;
      _cancelHideControlsTimer();
      _cancelProgressTimer();

      // Initialize new controller
      _controller = VideoPlayerController.networkUrl(Uri.parse(event.videoUrl));

      _controller!.addListener(() {
        if (_controller?.value.hasError == true && state is! VideoPlayerError) {
          log('Video error: ${_controller!.value.errorDescription}');
          add(DisposeVideoEvent());
        } else if (_controller?.value.isInitialized == true &&
            !_controller!.value.isPlaying &&
            _controller!.value.position >= _controller!.value.duration &&
            _controller!.value.duration > Duration.zero &&
            _lectureId != null &&
            _courseId != null &&
            _userId != null) {
          log('Video completed naturally');
          add(VideoCompletedEvent(lectureId: _lectureId!, courseId: _courseId!, userId: _userId!));
        }
      });

      await _controller!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Video initialization timed out');
        },
      );
      log('Video initialized: duration=${_controller!.value.duration}');

      if (event.startPosition != null && event.startPosition! < _controller!.value.duration) {
        await _controller!.seekTo(event.startPosition!);
        _lastPosition = event.startPosition!;
        log('Seeked to start position: ${event.startPosition}');
      }

      _startProgressTimer();

      emit(VideoPlayerReady(
        controller: _controller!,
        duration: _controller!.value.duration,
        position: event.startPosition ?? Duration.zero,
        isPlaying: false,
        isFullscreen: false,
        showControls: true,
        isBuffering: false,
        playbackSpeed: 1.0,
        videoUrl: _currentVideoUrl!,
        watchedDuration: _totalWatchedDuration,
        isCompleted: false,
      ));

      _startHideControlsTimer();
    } catch (e, stackTrace) {
      log('Error initializing video: $e\n$stackTrace');
      _cancelProgressTimer();
      emit(VideoPlayerError('Failed to initialize video: $e', videoUrl: event.videoUrl));
    }
  }

  Future<void> _onPlayVideo(PlayVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null) {
      await _controller!.play();
      final currentState = state as VideoPlayerReady;
      log('Playing video');
      emit(currentState.copyWith(isPlaying: true, showControls: true));
      _startHideControlsTimer();
    }
  }

  Future<void> _onPauseVideo(PauseVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null) {
      await _controller!.pause();
      final currentState = state as VideoPlayerReady;
      log('Pausing video');
      emit(currentState.copyWith(isPlaying: false, showControls: true));
      _cancelHideControlsTimer();
    }
  }

  void _onTogglePlayPause(TogglePlayPauseEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady && _controller != null) {
      final currentState = state as VideoPlayerReady;
      log('Toggling play/pause, current isPlaying: ${currentState.isPlaying}');
      if (currentState.isPlaying) {
        add(PauseVideoEvent());
      } else {
        add(PlayVideoEvent());
      }
    }
  }

  Future<void> _onSeekVideo(SeekVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null) {
      final currentState = state as VideoPlayerReady;
      final clampedPosition = event.position < Duration.zero
          ? Duration.zero
          : (event.position > _controller!.value.duration ? _controller!.value.duration : event.position);

      await _controller!.seekTo(clampedPosition);
      _lastPosition = clampedPosition;
      log('Seeked to: $clampedPosition');
      emit(currentState.copyWith(position: clampedPosition, showControls: true));
      _startHideControlsTimer();
    }
  }

  Future<void> _onToggleFullscreen(ToggleFullscreenEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;
      final isFullscreen = !currentState.isFullscreen;
      log('Toggling fullscreen to: $isFullscreen');

      try {
        if (isFullscreen) {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }

        emit(currentState.copyWith(isFullscreen: isFullscreen, showControls: true));
        _startHideControlsTimer();
      } catch (e) {
        log('Error toggling fullscreen: $e');
      }
    }
  }

  void _onShowControls(ShowControlsEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;
      log('Showing controls');
      emit(currentState.copyWith(showControls: true));
      _startHideControlsTimer();
    }
  }

  void _onHideControls(HideControlsEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;
      if (currentState.isPlaying) {
        log('Hiding controls');
        emit(currentState.copyWith(showControls: false));
      }
    }
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;

      // Track watched duration
      if (currentState.isPlaying && event.position > _lastPosition) {
        final increment = event.position - _lastPosition;
        if (increment > Duration.zero && increment < const Duration(seconds: 2)) {
          _totalWatchedDuration += increment;
        }
      }
      _lastPosition = event.position;

      emit(currentState.copyWith(
        position: event.position,
        duration: event.duration,
        isBuffering: _controller?.value.isBuffering ?? false,
        watchedDuration: _totalWatchedDuration,
      ));

      // Check if video is completed (watched 90% or more)
      if (event.duration > Duration.zero && !currentState.isCompleted) {
        final watchedPercentage = _totalWatchedDuration.inSeconds / event.duration.inSeconds;
        if (watchedPercentage >= 0.9) {
          log('Video completion threshold reached: ${watchedPercentage * 100}%');
          add(VideoCompletedEvent(
            lectureId: _lectureId!,
            courseId: _courseId!,
            userId: _userId!,
          ));
        }
      }
    }
  }

  Future<void> _onChangePlaybackSpeed(ChangePlaybackSpeedEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null) {
      await _controller!.setPlaybackSpeed(event.speed);
      final currentState = state as VideoPlayerReady;
      log('Changed playback speed to: ${event.speed}x');
      emit(currentState.copyWith(playbackSpeed: event.speed));
    }
  }

  // Enhanced VideoPlayerBloc _onVideoCompleted method
Future<void> _onVideoCompleted(VideoCompletedEvent event, Emitter<VideoPlayerState> emit) async {
  if (state is VideoPlayerReady) {
    final currentState = state as VideoPlayerReady;
    log('Video marked as completed for lectureId: ${event.lectureId}');

    // Create params
    final params = UpdateProgressParam(
      userId: event.userId,
      courseId: event.courseId,
      lectureIndex: int.parse(event.lectureId),
      isCompleted: true,
      watchedDurationSeconds: _totalWatchedDuration.inSeconds,
      lastAccessedAt: DateTime.now(),
    );

    // Call UpdateProgressUseCase
    final result = await serviceLocator<UpdateProgressUseCase>().call(params: params);
    result.fold(
      (failure) {
        log('❌ Failed to update progress: $failure');
        // Still mark as completed locally even if server update fails
        emit(currentState.copyWith(isCompleted: true));
      },
      (success) {
        log('✅ Progress updated successfully');
        emit(currentState.copyWith(isCompleted: true));
      },
    );
  }
}

  Future<void> _onDisposeVideo(DisposeVideoEvent event, Emitter<VideoPlayerState> emit) async {
    log('Disposing video resources');
    await _controller?.dispose();
    _controller = null;
    _cancelHideControlsTimer();
    _cancelProgressTimer();
    _currentVideoUrl = null;
    _totalWatchedDuration = Duration.zero;
    _lastPosition = Duration.zero;
    _lectureId = null;
    _courseId = null;
    _userId = null;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    emit(VideoPlayerInitial());
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    if (state is VideoPlayerReady && (state as VideoPlayerReady).isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        add(HideControlsEvent());
      });
    }
  }

Future<void> _onReplayVideo(ReplayVideoEvent event, Emitter<VideoPlayerState> emit) async {
  if (state is VideoPlayerReady && _controller != null) {
    final currentState = state as VideoPlayerReady;
    
    // Reset completion state and seek to beginning
    await _controller!.seekTo(Duration.zero);
    _lastPosition = Duration.zero;
    _totalWatchedDuration = Duration.zero; // Reset watched duration for new viewing
    
    // Emit state with completion reset
    emit(currentState.copyWith(
      isCompleted: false,
      position: Duration.zero,
      watchedDuration: Duration.zero,
      isPlaying: false,
      showControls: true,
    ));
    
    // Start playing
    await _controller!.play();
    emit(currentState.copyWith(
      isCompleted: false,
      position: Duration.zero,
      watchedDuration: Duration.zero,
      isPlaying: true,
      showControls: true,
    ));
    
    _startHideControlsTimer();
    log('Video replaying from beginning');
  }
}

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  void _startProgressTimer() {
    _cancelProgressTimer();
    if (_controller != null && _lectureId != null && _courseId != null && _userId != null) {
      _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (_controller?.value.isInitialized == true) {
          add(UpdateProgressEvent(
            position: _controller!.value.position,
            duration: _controller!.value.duration,
          ));
        }
      });
    }
  }

  void _cancelProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  @override
  Future<void> close() async {
    log('Closing VideoPlayerBloc');
    await _controller?.dispose();
    _cancelHideControlsTimer();
    _cancelProgressTimer();
    _currentVideoUrl = null;
    _totalWatchedDuration = Duration.zero;
    _lastPosition = Duration.zero;
    _lectureId = null;
    _courseId = null;
    _userId = null;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return super.close();
  }
}

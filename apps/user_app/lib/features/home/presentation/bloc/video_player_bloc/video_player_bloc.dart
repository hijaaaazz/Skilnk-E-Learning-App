import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:user_app/service_locator.dart';
import '../../../data/models/update_progress_params.dart';
import '../../../domain/usecases/udpate_course_progress.dart';
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
  bool _isDisposed = false;
  bool _isInitializing = false;
  bool _wasCompleted = false; // Track if lecture was previously completed

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
    if (_isInitializing) return;
    
    try {
      _isInitializing = true;
      
      if (event.videoUrl.isEmpty || !Uri.parse(event.videoUrl).isAbsolute) {
        throw Exception('Invalid video URL');
      }

      if (event.lectureId == null || event.courseId == null || event.userId == null) {
        throw Exception('Lecture ID, Course ID, or User ID cannot be null');
      }

      // Only show loading if we don't have a ready state
      if (state is! VideoPlayerReady) {
        emit(VideoPlayerLoading());
      }
      
      log('Initializing video: ${event.videoUrl}');

      _currentVideoUrl = event.videoUrl;
      _lectureId = event.lectureId;
      _courseId = event.courseId;
      _userId = event.userId;
      _isDisposed = false;

      // Check if this lecture was previously completed
      _wasCompleted = event.wasCompleted ?? false;
      
      // Reset tracking variables for fresh start
      _totalWatchedDuration = Duration.zero;
      _lastPosition = Duration.zero;

      // Dispose old controller
      await _controller?.dispose();
      _controller = null;
      _cancelHideControlsTimer();
      _cancelProgressTimer();

      // Initialize new controller
      _controller = VideoPlayerController.networkUrl(Uri.parse(event.videoUrl));
      
      // Add listener for controller state changes
      _controller!.addListener(_videoControllerListener);

      await _controller!.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Video initialization timed out');
        },
      );

      if (_isDisposed) return;

      log('Video initialized: duration=${_controller!.value.duration}');

      // For completed videos, always start from beginning unless user specifically wants to resume
      Duration startPosition = Duration.zero;
      
      // Only use saved position if video wasn't completed and user has progress
      if (!_wasCompleted && event.startPosition != null && 
          event.startPosition! > Duration.zero && 
          event.startPosition! < _controller!.value.duration) {
        startPosition = event.startPosition!;
        _totalWatchedDuration = event.startPosition!;
        _lastPosition = event.startPosition!;
        
        await _controller!.seekTo(startPosition);
        log('Resumed from saved position: $startPosition');
      } else {
        log('Starting from beginning (completed video or no saved progress)');
      }

      _startProgressTimer();

      emit(VideoPlayerReady(
        controller: _controller!,
        duration: _controller!.value.duration,
        position: _controller!.value.position,
        isPlaying: false,
        isFullscreen: false,
        showControls: true,
        isBuffering: false,
        playbackSpeed: 1.0,
        videoUrl: _currentVideoUrl!,
        watchedDuration: _totalWatchedDuration,
        isCompleted: false, // Always start as not completed for fresh viewing
      ));

      _startHideControlsTimer();
    } catch (e, stackTrace) {
      log('Error initializing video: $e\n$stackTrace');
      _cancelProgressTimer();
      emit(VideoPlayerError('Failed to initialize video: $e', videoUrl: event.videoUrl));
    } finally {
      _isInitializing = false;
    }
  }

  void _videoControllerListener() {
    if (_controller == null || _isDisposed || _isInitializing) return;

    // Handle video errors
    if (_controller!.value.hasError && state is! VideoPlayerError) {
      log('Video error: ${_controller!.value.errorDescription}');
      add(DisposeVideoEvent());
      return;
    }

    // Handle natural video completion (reached the end)
    if (_controller!.value.isInitialized &&
        !_controller!.value.isPlaying &&
        _controller!.value.position >= _controller!.value.duration &&
        _controller!.value.duration > Duration.zero &&
        _controller!.value.position > Duration(seconds: 1) && // Ensure it's not just initialization
        _lectureId != null &&
        _courseId != null &&
        _userId != null &&
        state is VideoPlayerReady &&
        !(state as VideoPlayerReady).isCompleted) {
      log('Video completed naturally at end');
      add(VideoCompletedEvent(
        lectureId: _lectureId!,
        courseId: _courseId!,
        userId: _userId!,
      ));
    }
  }

  Future<void> _onPlayVideo(PlayVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
      try {
        await _controller!.play();
        final currentState = state as VideoPlayerReady;
        log('Playing video');
        
        emit(currentState.copyWith(
          isPlaying: true,
          showControls: true,
        ));
        
        _startHideControlsTimer();
      } catch (e) {
        log('Error playing video: $e');
      }
    }
  }

  Future<void> _onPauseVideo(PauseVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
      try {
        await _controller!.pause();
        final currentState = state as VideoPlayerReady;
        log('Pausing video');
        
        emit(currentState.copyWith(
          isPlaying: false,
          showControls: true,
        ));
        
        _cancelHideControlsTimer();
      } catch (e) {
        log('Error pausing video: $e');
      }
    }
  }

  void _onTogglePlayPause(TogglePlayPauseEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
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
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
      try {
        final currentState = state as VideoPlayerReady;
        final clampedPosition = event.position < Duration.zero
            ? Duration.zero
            : (event.position > _controller!.value.duration 
                ? _controller!.value.duration 
                : event.position);

        await _controller!.seekTo(clampedPosition);
        _lastPosition = clampedPosition;
        log('Seeked to: $clampedPosition');

        // If seeking backwards from completion, reset completion status
        if (currentState.isCompleted && clampedPosition < _controller!.value.duration) {
          emit(currentState.copyWith(
            position: clampedPosition,
            showControls: true,
            isCompleted: false, // Reset completion when seeking back
          ));
        } else {
          emit(currentState.copyWith(
            position: clampedPosition,
            showControls: true,
          ));
        }
        
        _startHideControlsTimer();
      } catch (e) {
        log('Error seeking video: $e');
      }
    }
  }

  Future<void> _onToggleFullscreen(ToggleFullscreenEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && !_isDisposed) {
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
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        }

        emit(currentState.copyWith(
          isFullscreen: isFullscreen,
          showControls: true,
        ));
        
        _startHideControlsTimer();
      } catch (e) {
        log('Error toggling fullscreen: $e');
      }
    }
  }

  void _onShowControls(ShowControlsEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady && !_isDisposed) {
      final currentState = state as VideoPlayerReady;
      log('Showing controls');
      
      emit(currentState.copyWith(showControls: true));
      _startHideControlsTimer();
    }
  }

  void _onHideControls(HideControlsEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady && !_isDisposed) {
      final currentState = state as VideoPlayerReady;
      
      if (currentState.isPlaying) {
        log('Hiding controls');
        emit(currentState.copyWith(showControls: false));
      }
    }
  }

  void _onUpdateProgress(UpdateProgressEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady && !_isDisposed && !_isInitializing) {
      final currentState = state as VideoPlayerReady;

      // Track watched duration more accurately
      if (currentState.isPlaying && event.position > _lastPosition) {
        final increment = event.position - _lastPosition;
        if (increment > Duration.zero && increment < const Duration(seconds: 3)) {
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

      // Check completion threshold (90% watched OR reached the end)
      if (event.duration > Duration.zero && !currentState.isCompleted) {
        final watchedPercentage = _totalWatchedDuration.inSeconds / event.duration.inSeconds;
        final positionPercentage = event.position.inSeconds / event.duration.inSeconds;
        
        if (watchedPercentage >= 0.9 || positionPercentage >= 0.98) {
          log('Video completion threshold reached: watched=${watchedPercentage * 100}%, position=${positionPercentage * 100}%');
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
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
      try {
        await _controller!.setPlaybackSpeed(event.speed);
        final currentState = state as VideoPlayerReady;
        log('Changed playback speed to: ${event.speed}x');
        
        emit(currentState.copyWith(playbackSpeed: event.speed));
      } catch (e) {
        log('Error changing playback speed: $e');
      }
    }
  }

  Future<void> _onVideoCompleted(VideoCompletedEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && !_isDisposed) {
      final currentState = state as VideoPlayerReady;
      log('Video marked as completed for lectureId: ${event.lectureId}');

      // Pause the video when completed
      if (_controller != null && _controller!.value.isPlaying) {
        await _controller!.pause();
      }

      // Update state first
      emit(currentState.copyWith(
        isCompleted: true,
        isPlaying: false,
        showControls: true,
      ));

      // Then update progress in background
      try {
        final params = UpdateProgressParam(
          userId: event.userId,
          courseId: event.courseId,
          lectureIndex: int.parse(event.lectureId),
          isCompleted: true,
          watchedDurationSeconds: _totalWatchedDuration.inSeconds,
          lastAccessedAt: DateTime.now(),
        );

        final result = await serviceLocator<UpdateProgressUseCase>().call(params: params);
        
        result.fold(
          (failure) => log('❌ Failed to update progress: $failure'),
          (success) => log('✅ Progress updated successfully'),
        );
      } catch (e) {
        log('Error updating progress: $e');
      }
    }
  }

  Future<void> _onReplayVideo(ReplayVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null && !_isDisposed) {
      try {
        final currentState = state as VideoPlayerReady;
        log('Replaying video from beginning');

        // Pause and reset
        await _controller!.pause();
        await _controller!.seekTo(Duration.zero);
        
        // Reset all tracking variables
        _lastPosition = Duration.zero;
        _totalWatchedDuration = Duration.zero;
        _wasCompleted = false; // Reset completion flag

        // Update state with reset values
        emit(currentState.copyWith(
          isCompleted: false,
          position: Duration.zero,
          watchedDuration: Duration.zero,
          isPlaying: false,
          showControls: true,
        ));

        // Small delay then play
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (!_isDisposed && _controller != null) {
          await _controller!.play();
          
          emit(currentState.copyWith(
            isCompleted: false,
            position: Duration.zero,
            watchedDuration: Duration.zero,
            isPlaying: true,
            showControls: true,
          ));

          _startHideControlsTimer();
        }
      } catch (e) {
        log('Error replaying video: $e');
      }
    }
  }

  Future<void> _onDisposeVideo(DisposeVideoEvent event, Emitter<VideoPlayerState> emit) async {
    log('Disposing video resources');
    _isDisposed = true;
    _isInitializing = false;
    
    _controller?.removeListener(_videoControllerListener);
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
    _wasCompleted = false;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    emit(VideoPlayerInitial());
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    
    if (state is VideoPlayerReady && (state as VideoPlayerReady).isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (!_isDisposed) {
          add(HideControlsEvent());
        }
      });
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
        if (_controller?.value.isInitialized == true && !_isDisposed && !_isInitializing) {
          add(UpdateProgressEvent(
            position: _controller!.value.position,
            duration: _controller!.value.duration,
          ));
        } else if (_isDisposed) {
          timer.cancel();
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
    _isDisposed = true;
    _isInitializing = false;
    
    _controller?.removeListener(_videoControllerListener);
    await _controller?.dispose();
    
    _cancelHideControlsTimer();
    _cancelProgressTimer();
    
    _currentVideoUrl = null;
    _totalWatchedDuration = Duration.zero;
    _lastPosition = Duration.zero;
    _lectureId = null;
    _courseId = null;
    _userId = null;
    _wasCompleted = false;

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return super.close();
  }
}

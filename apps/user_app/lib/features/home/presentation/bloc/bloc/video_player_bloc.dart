import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:user_app/features/home/data/models/update_progress_params.dart';
import 'package:user_app/features/home/domain/usecases/udpate_course_progress.dart';
import 'package:user_app/service_locator.dart';
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
  }

  Future<void> _onInitializeVideo(InitializeVideoEvent event, Emitter<VideoPlayerState> emit) async {
    try {
      emit(VideoPlayerLoading());
      log('Initializing video: ${event.videoUrl}');
      _currentVideoUrl = event.videoUrl;
      _totalWatchedDuration = event.startPosition;

      await _controller?.dispose();
      _cancelHideControlsTimer();
      _cancelProgressTimer();

      _controller = VideoPlayerController.networkUrl(Uri.parse(event.videoUrl));
      
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          log('Video error: ${_controller!.value.errorDescription}');
          add(DisposeVideoEvent());
          emit(VideoPlayerError('Video error: ${_controller!.value.errorDescription}', videoUrl: _currentVideoUrl!));
        } else if (_controller!.value.isInitialized && 
                   !_controller!.value.isPlaying && 
                   _controller!.value.position >= _controller!.value.duration &&
                   _controller!.value.duration > Duration.zero) {
          log('Video completed naturally');
          add(VideoCompletedEvent());
        }
      });

      await _controller!.initialize();
      log('Video initialized: duration=${_controller!.value.duration}');

      if (event.startPosition != Duration.zero && event.startPosition < _controller!.value.duration) {
        await _controller!.seekTo(event.startPosition);
        _lastPosition = event.startPosition;
        log('Seeked to start position: ${event.startPosition}');
      }

      _startProgressTimer();

      emit(VideoPlayerReady(
        controller: _controller!,
        duration: _controller!.value.duration,
        position: event.startPosition,
        isPlaying: false,
        isFullscreen: false,
        showControls: true,
        isBuffering: false,
        playbackSpeed: 1.0,
        videoUrl: _currentVideoUrl!,
        watchedDuration: _totalWatchedDuration,
      ));

      _startHideControlsTimer();
    } catch (e, stackTrace) {
      log('Error initializing video: $e\n$stackTrace');
      emit(VideoPlayerError('Failed to initialize video: $e', videoUrl: event.videoUrl));
    }
  }

  void _onPlayVideo(PlayVideoEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady && _controller != null) {
      await _controller!.play();
      final currentState = state as VideoPlayerReady;
      log('Playing video');
      emit(currentState.copyWith(isPlaying: true, showControls: true));
      _startHideControlsTimer();
    }
  }

  void _onPauseVideo(PauseVideoEvent event, Emitter<VideoPlayerState> emit) async {
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
      final clampedPosition = 
    event.position < Duration.zero
        ? Duration.zero
        : (event.position > _controller!.value.duration
            ? _controller!.value.duration
            : event.position);


      await _controller!.seekTo(clampedPosition);
      _lastPosition = clampedPosition;
      log('Seeked to: $clampedPosition');
      emit(currentState.copyWith(position: clampedPosition, showControls: true));
      _startHideControlsTimer();
    }
  }

  void _onToggleFullscreen(ToggleFullscreenEvent event, Emitter<VideoPlayerState> emit) async {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;
      final isFullscreen = !currentState.isFullscreen;
      log('Toggling fullscreen to: $isFullscreen');

      try {
        

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
      
      // Track watched duration more accurately
      if (currentState.isPlaying && event.position > _lastPosition) {
        final increment = event.position - _lastPosition;
        if (increment > Duration.zero && increment < Duration(seconds: 2)) {
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
      if (event.duration > Duration.zero) {
        final watchedPercentage = _totalWatchedDuration.inSeconds / event.duration.inSeconds;
        if (watchedPercentage >= 0.9 && !currentState.isCompleted) {
          log('Video completion threshold reached: ${watchedPercentage * 100}%');
          add(VideoCompletedEvent());
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

  void _onVideoCompleted(VideoCompletedEvent event, Emitter<VideoPlayerState> emit) {
    if (state is VideoPlayerReady) {
      final currentState = state as VideoPlayerReady;
      final result = serviceLocator<UpdateProgressUseCase>().call(params:UpdateProgressParam());
      log('Video marked as completed');
      emit(currentState.copyWith(isCompleted: true));
    }
  }

  void _onDisposeVideo(DisposeVideoEvent event, Emitter<VideoPlayerState> emit) async {
    log('Disposing video resources');
    await _controller?.dispose();
    _controller = null;
    _cancelHideControlsTimer();
    _cancelProgressTimer();
    _currentVideoUrl = null;
    _totalWatchedDuration = Duration.zero;
    _lastPosition = Duration.zero;
    
    // Reset system UI
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    emit(VideoPlayerInitial());
  }

  void _startHideControlsTimer() {
    _cancelHideControlsTimer();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      add(HideControlsEvent());
    });
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  void _startProgressTimer() {
    _cancelProgressTimer();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_controller != null && _controller!.value.isInitialized) {
        add(UpdateProgressEvent(
          position: _controller!.value.position,
          duration: _controller!.value.duration,
        ));
      }
    });
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
    
    // Reset system UI
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    return super.close();
  }
}
